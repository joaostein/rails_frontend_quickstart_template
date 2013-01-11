# Helpers > Replace Line

def replace_line(path, options = {})
  lines = File.open(path).readlines
  lines.map! do |line|
    if line.match(options[:match])
      line = "#{options[:with].rstrip}\n"
    end
    line
  end 

  run "rm #{path}"
  File.open(path, 'w+') { |file| file << lines.join }
end


# Removes the default index specified on default

run "rm public/index.html"

# Creates the Procfile necessary to boot the server

file "Procfile", <<-CODE
web: bundle exec rails server thin -p $PORT
CODE

# Add all the necessary basic gems to Gemfile

file "Gemfile", <<-GEMFILE, :force => true
source 'https://rubygems.org'

gem 'rails', '3.2.11'
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

file ".gitignore", <<-CODE, :force => true
# See http://help.github.com/ignore-files/ for more about ignoring files.
#
# If you find yourself ignoring temporary files generated by your text editor
# or operating system, you probably want to add a global ignore instead:
#   git config --global core.excludesfile ~/.gitignore_global

# Ignore bundler config
/.bundle

# Ignore the default SQLite database.
/db/*.sqlite3

# Ignore all logfiles and tempfiles.
/log/*.log
/tmp

# Read about how to use .gitignore: http://h5bp.com/ae

# Numerous always-ignore extensions
*.diff
*.err
*.orig
*.log
*.rej
*.swo
*.swp
*.vi
*~
*.sass-cache

# OS or Editor folders
.DS_Store
._*
Thumbs.db
.cache
.project
.settings
.tmproj
nbproject
*.sublime-project
*.sublime-workspace

# Dreamweaver added files
_notes
dwsync.xml

# Komodo
*.komodoproject
.komodotools

# Espresso
*.esproj
*.espressostorage

# Rubinius
*.rbc

# Folders to ignore
.hg
.svn
.CVS
intermediate
publish
.idea

# build script local files
build/buildinfo.properties
build/config/buildinfo.properties
CODE

# Download JavaScript libraries

inside('vendor/assets/javascripts') do
    run 'curl -s https://raw.github.com/dotjay/hashgrid/master/hashgrid.js > hashgrid.js'
    run 'curl -s https://raw.github.com/imsky/holder/master/holder.js > holder.js'
    run 'curl -s http://modernizr.com/downloads/modernizr.js > modernizr.js'
    run 'curl -s https://raw.github.com/keithclark/selectivizr/master/selectivizr.js > selectivizr.js'
  end

# Database Config

file "config/database.yml", <<-DATABASE, :force => true
development:
  adapter: postgresql
  database: #{app_name}_development
  host: localhost
  user: postgres
  password:
  pool: 5
  timeout: 5000
  template: template0

test: &test
  adapter: postgresql
  database: #{app_name}_test
  host: localhost
  user: postgres
  password:
  pool: 5
  timeout: 5000
  template: template0

production:
  adapter: postgresql
  database: #{app_name}_production
  host: localhost
  user: postgres
  password:
  pool: 5
  timeout: 5000
  template: template0

cucumber:
  <<: *test

DATABASE

# Configure precompile

replace_line('config/environments/production.rb', :match => /config.assets.precompile \+=/, :with => '  config.assets.precompile += %w( modernizr.js selectivizr.js holder.js hashgrid.js )')


# Generate Contollers

generate(:controller, "home", "index")
generate(:controller, "styleguide")

# Generate default routes

replace_line('config/routes.rb', :match => /get "home\/index"/, :with => '')
route "root :to => 'home#index'"
route "match 'styleguide' => 'styleguide#index'"

# Download assets basic boilerplate based on SMACSS

inside('app') do
    run 'rm -rf assets/*'
    run "curl -L https://github.com/joaostein/rails_frontend_assets_template/tarball/master | tar zx --strip-components=1 -C assets --exclude '*.slim'"
  end

# Update/create view's files

inside('app/views/layouts') do
    run 'rm application.html.erb'
    run 'curl https://raw.github.com/joaostein/rails_frontend_assets_template/master/application.slim > application.slim'
  end

inside('app/views/styleguide') do
    run 'curl https://raw.github.com/joaostein/rails_frontend_assets_template/master/style-guide.slim > index.slim'
  end

inside('app/views/home') do
    run 'rm -rf *'
  end

file "app/views/home/index.slim", <<-CODE
h1 Homepage
p Lorem ipsum
CODE

# Run db:create:all

rake("db:create:all")

# Git init/first commit

git :init
git :add => '.'
git :commit => "-a -m 'First Commit'"

