require "rubygems"
require "jekyll"
require "jekyll/commands/ghdeploy"

module JekyllGhDeploy
	class Site   
		
		def initialize (repo, message)
			system("clear")
			puts "\n\e[1m\e[33mWelcome to Jekyll GhDeploy\e[39m\e[0m"
			
			@repo = "https://github.com/" + repo
			@message = message
		end

		def deploy
			clone

			Dir.chdir("clone/") do
				prepare
				
				if !system("cd _site; git log>/dev/null") 
					initial_commits
				else
					build
					commit
				end
				
				push
			end
		end

		def clone
			puts "\n\e[1mCloning repository\e[0m\n\n"

			FileUtils.rm_rf("clone")
			
			exit unless system("git clone  '.git/' 'clone/'")
		end

		def initial_commits
			puts "\n\e[1mBuilding and commiting for every commit in master branch\e[0m\n\n"
			
			n = -1 + `git rev-list --count master`.to_i
			#n = n-1
			commit_hash=Array.new()
			message=Array.new()
			
			#This is an iteration through every commit inside of master branch
			#To get the ith commit message we need to skip n-i commits starting from HEAD 
	
			for i in 0..n do
				commit_hash[i]=`git log --skip=#{n-i} --max-count=1 --pretty=%H`
				message[i] =`git log --skip=#{n-i} --max-count=1 --pretty=%s`
			end
			
			for i in 0..n do 
				@message = message[i]
				system("
					git reset --hard #{commit_hash[i]}
					echo -e '\n'
					")
				build
				commit
			end	
		end

		def prepare
			puts "\n\e[1mPreparing _site\e[0m\n\n"
			
			FileUtils.rm_rf("_site")
			Dir.mkdir "_site"
			
			Dir.chdir("_site/") do
				exit unless  system("
							 	git init
								echo -e '\n'
								git remote add origin #{@repo}
								git checkout -b gh-pages
								echo -e '\n'	
							")
				
				remote_branch = `git ls-remote --heads origin gh-pages`		
				
				if remote_branch.empty?
					system("touch .nojekyll")
				else
					exit unless system("git pull --rebase origin gh-pages")
				end
			end
		end

		def build
			puts "\n\e[1mBuilding\e[0m\n\n"	

          	Jekyll::Commands::Build.process(options = {})
		end	

		def commit
			puts "\n\e[1mCommiting changes\e[0m\n\n"
			
			Dir.chdir("_site/") do
				exit unless  system("
							 	git status
								echo -e '\n'
								git add -A
								echo -e '\n'
								git status
								echo -e '\n'
								git commit -m '#{@message}'
							")
			end	
		end

		def push
			puts "\n\e[1mPushing to #{@repo} gh-pages branch\e[0m\n\n"
			
			Dir.chdir("_site/") do
				exit unless	system("git push origin gh-pages")
			end	
		end

		def clean
			puts "\n\n\e[1mQuiting...\e[0m\n\n"
			
			FileUtils.rm_rf("clone")
		end
	end	
end

