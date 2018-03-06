desc 'The default task; lists tasks'
task :default do
  puts `rake --tasks`
end

desc 'Displays the current version'
task :version do
  puts "Current version: #{JekyllGhDeploy::VERSION}"
end

desc 'Releases the gem'
task :release do |_t|
  system 'gem build jekyll-ghdeploy.gemspec'
  system "git tag v#{JekyllGhDeploy::VERSION}"
  system 'git push --tags'
  system "gem push jekyll-scholar-#{JekyllGhDeploy::VERSION}.gem"
end
