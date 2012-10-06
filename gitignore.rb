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