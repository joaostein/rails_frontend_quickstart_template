# Removes the default index specified on default

run "rm public/index.html"

# Creates the Procfile necessary to boot the server

file "Procfile", <<-CODE
web: bundle exec rails server thin -p $PORT
CODE

# Add all the necessary basic gems to Gemfile

file "Gemfile", <<-GEMFILE, :force => true
source 'https://rubygems.org'

gem 'rails', '3.2.8'
gem 'jquery-rails'
gem 'pg'
gem 'slim'
gem 'thin'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'compass-rails'
  gem 'susy'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
GEMFILE

# Create example project file for Sublime Text 2.

file "example.sublime-project", <<-CODE
{
  "folders":
  [
    {
      "folder_exclude_patterns": ["db", "lib", "doc", "log", "tmp", "script", "test"],
      "file_exclude_patterns": ["config.ru", "Gemfile.lock", "Procfile", "Rakefile", "README.rdoc", ".gitkeep"]
    }
  ]
}
CODE

# Create .gitignore

run 'curl -s https://raw.github.com/joaostein/frontend_template/master/gitignore.rb > .gitignore'

# Download JavaScript libraries

inside('vendor/assets/javascripts') do
    run 'curl -s https://raw.github.com/dotjay/hashgrid/master/hashgrid.js > hashgrid.js'
    run 'curl -s https://raw.github.com/imsky/holder/master/holder.js > holder.js'
    run 'curl -s http://modernizr.com/downloads/modernizr.js > modernizr.js'
    run 'curl -s https://raw.github.com/keithclark/selectivizr/master/selectivizr.js > selectivizr.js'
  end
















