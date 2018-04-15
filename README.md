# Jekyll GhDeploy
[![Build Status](https://travis-ci.com/nickgarlis/jekyll-ghdeploy.svg?token=qbXC3ZD5xJoyX2qqbQST&branch=master)](https://travis-ci.com/nickgarlis/jekyll-ghdeploy)

If you are using non-whitelisted plugins for your Jekyll site then you probably can't host on Github Pages.
Jekyll GhDeploy is meant to take away the pain of building and pushing your Jekyll site to Github while keeping it version controlled.     

## Installation

Add these lines to your site's Gemfile:

```ruby
group :jekyll_plugins do
   gem "jekyll-ghdeploy"
end

```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install jekyll-ghdeploy

## Usage

Specify your repository inside of your configuration file with `username` being
your Github username and `repository` being your repository's name. 

    repository: username/repository

Execute the command by typing `bundle exec jekyll ghdeploy`

    $ bundle exec jekyll ghdeploy

You can alternatively specify your repository while executing the command.

    $ bundle exec jekyll ghdeploy username/repository

## Options

| Option | Description |
|--------|-------------|
| `-d` or `--docs` | Built site is stored inside of `docs` directory. Note that this option commits any staged files and pushes to master. |
| `-m` or `--message` | Custom commit message |

## Contributing

If you have found a bug or would like to ask a question please open an issue.
Pull requests are welcome.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

