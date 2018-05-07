require 'rubygems'
require 'jekyll'
require 'jekyll/commands/ghdeploy'

module JekyllGhDeploy
  class Site
    def initialize(repo, options = {})
      system 'clear'
      puts "\n\e[1m\e[33mWelcome to Jekyll GhDeploy\e[39m\e[0m"

      @repo = 'https://github.com/' + repo

      if options['docs'] == true
        @dir = 'docs'
        @branch = 'master'
        @message = options['message']
      else
        @dir = '_site'
        @branch = 'gh-pages'
        @message = `git log -1 --pretty=%s`
        @no_history = options['no_history']
      end
    end

    def deploy
      clone

      case @dir
      when 'docs'
        deploy_docs
      when '_site'
        deploy_site
      end
    end

    def deploy_docs
      Dir.chdir('clone/') do
        exit unless system 'git remote remove origin'
        exit unless system "git remote add origin #{@repo}"

        FileUtils.rm_rf('docs')
        build

        Dir.chdir('docs') { system 'touch .nojekyll' }

        commit
        push
      end

      puts "\n\e[1mUpdating local repository\e[0m"

      exit unless system 'git stash'
      exit unless system "git pull --rebase origin #{@branch}"
      exit unless system 'git stash pop'
    end

    def deploy_site
      Dir.chdir('clone/') do
        prepare_site

        if !system 'cd _site; git log>/dev/null' && !@no_history
          initial_commits
        else
          build
          commit
        end

        push
      end
    end

    def clone
      puts "\n\e[1mCloning repository\e[0m"

      FileUtils.rm_rf('clone')

      exit unless system "git clone '.git/' 'clone/'"

      copy_staged_files if @dir == 'docs'
    end

    def copy_staged_files
      staged_files = []

      `git diff --name-only --cached`.each_line do |line|
        staged_files.push(line.chomp)
      end

      FileUtils.cp_r staged_files, 'clone'
    end

    def initial_commits
      puts "\n\e[1mBuilding and commiting for every commit in master branch\e[0m"

      n = -1 + `git rev-list --count master`.to_i

      commit_hash = []
      message = []

      # This is an iteration through every commit inside of master branch
      # To get the ith commit message we need to skip n-i commits starting from HEAD

      for i in 0..n do
        commit_hash[i] = `git log --skip=#{n - i} --max-count=1 --pretty=%H`
        message[i] = `git log --skip=#{n - i} --max-count=1 --pretty=%s`
      end

      for i in 0..n do
        @message = message[i]

        exit unless system "git reset --hard #{commit_hash[i]}"
        puts

        build
        commit
      end
    end

    def prepare_site
      puts "\n\e[1mPreparing _site\e[0m"

      FileUtils.rm_rf(@dir)
      Dir.mkdir(@dir)

      Dir.chdir(@dir) do
        exit unless system 'git init'
        exit unless system "git remote add origin #{@repo}"
        exit unless system "git checkout -b #{@branch}"

        remote_branch = `git ls-remote --heads origin gh-pages`

        if remote_branch.empty? || @no_history
          system 'touch .nojekyll'
        else
          exit unless system 'git pull --rebase origin gh-pages'
        end
      end
    end

    def build
      puts "\n\e[1mBuilding\e[0m"

      options = {}
      options['serving'] = false
      options['destination'] = @dir

      Jekyll::Commands::Build.process(options)
    end

    def commit
      puts "\n\e[1mCommiting changes\e[0m"

      Dir.chdir(@dir) do
        system 'git add -A'
        system 'git status'

        if @message.nil?
          puts 'Enter your commit message: '
          @message = gets
        end

        exit unless system "git commit -m '#{@message}'"
      end
    end

    def push
      puts "\n\e[1mPushing to #{@repo} #{@branch} branch\e[0m"

      option = @no_history ? '-f' : ''

      Dir.chdir(@dir) do
        exit unless system "git push #{option} origin #{@branch}"
      end
    end

    def clean
      puts "\n\n\e[1mQuiting...\e[0m"

      FileUtils.rm_rf('clone')
    end
  end
end
