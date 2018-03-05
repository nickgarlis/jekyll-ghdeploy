require 'jekyll-ghdeploy'
module Jekyll
  module Commands
    class GhDeploy < Command
      class << self
        def init_with_program(prog)
          prog.command(:ghdeploy) do |c|

            c.syntax "deploy REPOSITORY"
            
            c.description "Deploys your site to your gh-pages branch"
            
            c.action do |args, options|
              Jekyll::Commands::GhDeploy.process(args, options)
            end
          end
        end

        def process(args, options = {})

          config = YAML.load_file('_config.yml')    
          message = `git log -1 --pretty=%s`

          if args.empty? && config['repository'].blank?
            raise ArgumentError, "You must specify a repository."
          elsif args.empty?
            repo = config['repository']
          else 
            repo = args[0]
          end

          site = JekyllGhDeploy::Site.new(repo, message)
          
          at_exit do
           site.clean
          end 
          
          site.deploy

        end 
         
      end  
    end
  end
end
