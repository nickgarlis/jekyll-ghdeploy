require 'jekyll-ghdeploy'
module Jekyll
  module Commands
    class GhDeploy < Command
      class << self
        def init_with_program(prog)
          prog.command(:ghdeploy) do |c|
            c.syntax 'deploy REPOSITORY'
            c.description 'Deploys your site to your gh-pages branch'

            c.option 'docs', '--docs', '-d', 'Built site is stored into docs directory'
            c.option 'message', '--message MESSAGE', '-m MESSAGE', 'Specify a commit message'
            c.option 'no_history', '--no_history', '-n', 'Built site will have no commit history'

            c.action do |args, options|
              Jekyll::Commands::GhDeploy.process(args, options)
            end
          end
        end

        def process(args, options = {})
          config = YAML.load_file('_config.yml')

          if args.empty? && config['repository'].blank?
            raise ArgumentError, 'You must specify a repository.'
          elsif args.empty?
            repo = config['repository']
          else
            repo = args[0]
          end

          # if options['no_history'] && options['docs']
          #   raise Error, '-d and -n cannot work together'
          # end

          site = JekyllGhDeploy::Site.new(repo, options)

          at_exit do
            site.clean
          end

          site.deploy
        end
      end
    end
  end
end
