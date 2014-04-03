CMU-SV Students
===============

## Getting Started for Students
1. install rails using railsinstaller.org
1. rvm install ruby-1.9.3-p448
1. rvm --default use ruby-1.9.3-p448 ()
1. fork the project on github,
1. $ git clone http://github.com/URL/cmusv # to get the code
1. read {file:doc/Git_Directions.rdoc Git Directions}
1. $ cp config/database.default.yml config/database.yml -- (The default has fake username and password, replace database.yml this information with the real username and password) 
1. set your environment variables (optional step, only needed if you plan to work on these features)
   1. (Nitrous.io) modify .bashrc
   1. (Mac OS X) read http://david-martinez.tumblr.com/post/28083831730/environment-variables-and-mountain-lion (if you set them in bash, then RubyMine doesn't pick them up.)
   1. Note: This requires a restart. 
   1. Set these environment variables
      1. see http://whiteboard.sv.cmu.edu/pages/environment_variables for values
      1. LDAP_HOST 
      1. LDAP_PORT 
      1. LDAP_USERNAME
      1. LDAP_PASSWORD
      1. LDAP_ENCRYPTED 
      1. WHITEBOARD_SEARCHIFY_API_URL
      1. WHITEBOARD_SEARCHIFY_INDEX
      1. WHITEBOARD_SEARCHIFY_STAFF_INDEX
      1. WHITEBOARD_SALT
      1. WHITEBOARD_GOOGLE_USERNAME
      1. WHITEBOARD_GOOGLE_PASSWORD
      1. WHITEBOARD_GOOGLE_DOMAIN
      1. WHITEBOARD_S3_BUCKET
      1. WHITEBOARD_S3_KEY
      1. WHITEBOARD_S3_SECRET
      1. WHITEBOARD_TWIKI_USERNAME
      1. WHITEBOARD_TWIKI_PASSWORD
      1. WHITEBOARD_TWIKI_URL  
1. modify the db/seeds.rb and modify the example :your_name_here with yourself
    * Note: When you're prompted to login from the rails site with your email and password, you'll be redirected to google for authentication. After google approves of your credentials and sends you back to the rails site, the email used at time of login will be checked against the local db. This file populates the local db with your email/login data (see :your_name_here).
1. install postgres
   1. (Nitrous.io) parts install postgresql
   1. (Nitrous.io) parts start postgresql
   1. (Nitrous.io) createdb action-test
   1. (Nitrous.io) defaults to action and action-test
   1. (Local machine) install postgres see http://whiteboard.sv.cmu.edu/pages/postgres_rails
1. modify config/database.yml	
1. (skip on nitrous.io) install postgres database viewer (ie Navicat Lite http://www.navicat.com/en/download/download.html)
1. (skip on nitrous.io) install imagemagick
   1. (Directions for a mac)
   1. install brew see http://mxcl.github.com/homebrew/
   1. brew install imagemagick
1. (onlyon nitrous.io) parts install nodejs (To resolve error: Could not find a JavaScript runtime. See https://github.com/sstephenson/execjs for a list of available runtime)
1. bundle install
   1. If this doesn't work see note below
1. bundle exec rake db:schema:load
1. bundle exec rake db:seed (to load the seeds.rb data)
1. bundle exec rake RAILS_ENV="test" db:schema:load
1. (Is this necessary for foreman?) echo "RACK_ENV=development" >>.env
1. verify your configuration
   1. foreman start     or     rails s thin
   1. bundle exec rake spec  (Verify that all the tests pass)
   1. run the server in debug mode in an IDE.
1. Tip: you can pretend to be any user in your development environment by modifying the current_user method of the application_controller
1. bundle exec rake doc:app (Generates API documentation for your models, controllers, helpers, and libraries.)
1. modify RubyMine to use unicorn instead of webbrick. On the tool bar, Run -> Edit Configurations. Instead of default server, pick unicorn.

### Installing Git
If you installed rails using railsinstaller.org, you should have git installed.

* Mac users, Mountain Lion ships with 1.7.5.4 which is good enough.
* PC users,
   * Download "Full installer for official Git 1.7.6" here: http://code.google.com/p/msysgit/downloads/list (filename is Git-1.7.6-preview20110708.exe )
Run installer, accept license agreement, accept default installation directory, accept default shortcut options, keep all checkboxes checked
   * "Use Git Bash Only" radio button should be selected (per this article, avoids path conflicts)
   * "Use OpenSSH"
   * "Use Unix-style line endings"
   * (Note, these directions are from http://www.wiki.devchix.com)
* All users, from the terminal window or the command line, execute these commands but put in your own name and email address
   * git config --global user.name "Andrew Carnegie"
   * git config --global user.email andrew.carnegie@sv.cmu.edu
   * Create a user account on GitHub. Let the faculty know what your github user account is by modifying your profile page (e.g. http://whiteboard.sv.cmu.edu/people/AndrewCarnegie)
   * Setup your ssh keys with GitHub http://help.github.com/key-setup-redirect

#### Nokogiri issues

When i ran the bundle install, i got a strange error:

Installing nokogiri (1.5.0) with native extensions
Gem::Installer::ExtensionBuildError: ERROR: Failed to build gem native extension.

    /usr/local/rvm/rubies/ruby-1.9.2-p180/bin/ruby extconf.rb
    checking for libxml/parser.h... yes
    checking for libxslt/xslt.h... yes
    checking for libexslt/exslt.h... yes
    checking for iconv_open() in iconv.h... no
    checking for iconv_open() in -liconv... no

    libiconv is missing.  please visit http://nokogiri.org/tutorials/installing_nokogiri.html for help with installing dependencies.

    Followed steps on  http://nokogiri.org/tutorials/installing_nokogiri.html, but had to make sure the version of nokogiri gem being installed was '1.5.0'. So instead of the last command in the instructions page, I had to run this:

    gem install nokogiri -v '1.5.0' -- --with-xml2-include=/usr/local/Cellar/libxml2/2.7.8/include/libxml2 --with-xml2-lib=/usr/local/Cellar/libxml2/2.7.8/lib --with-xslt-dir=/usr/local/Cellar/libxslt/1.1.26 --with-iconv-include=/usr/local/Cellar/libiconv/1.13.1/include --with-iconv-lib=/usr/local/Cellar/libiconv/1.13.1/lib

#### PGSQL PG::Error

On running through the steps, sometimes you might encounter this error:

    PGSQL PG::Error (could not connect to server: No such file or directory
      Is the server running locally and accepting
      connections on Unix domain socket "/var/pgsql_socket/.s.PGSQL.5432"?
    ):

This is happening because OSX (Mountain Lion) comes up with a version of Postgres pre-installed. This is getting picked up instead of the one you manually installed. Doing one of the below should resolve the issue:

1. Add /usr/local/bin to the $PATH directory

If you used Homebrew for installation, then a symbolic link to the postgres executable is placed in the directory /usr/local/bin. Ensure it's there and then add that directory your PATH environment variable.

2. add a specific host to your database.yml

Your database.yml should look similar to the below:

    development:
        host:     localhost
        adapter:  postgresql
        encoding: utf8
        database: cmu_education
        ...

#### Rubymine debugger doesn't work

Ensure you have the right debugger gems installed. Follow this thread on [StackOverflow that clearly points](http://stackoverflow.com/questions/10323119/cannot-load-such-file-script-rails-getting-this-error-while-remote-debuggin/10325110#10325110) out the steps.

#### Failed to build gem native extension/No source for ruby-1.9.2 found

*This only applies if you use rbenv instead of rvm.*

    Building native extensions.  This could take a while...
    ERROR:  Error installing debugger:
            ERROR: Failed to build gem native extension.

            /Users/trongducdong/.rvm/rubies/ruby-1.9.3-rc1/bin/ruby extconf.rb --with-ruby-include=PATH_TO_HEADERS
    checking for vm_core.h... no
    checking for vm_core.h... no
    Makefile creation failed
    **************************************************************************
    No source for ruby-1.9.3-rc1 provided with debugger-ruby_core_source gem.
    **************************************************************************

While installing new ruby versions, the source libraries are not added by default. You can choose to keep the source libs by issuing this command:

    rbenv install 1.9.2-p180 --keep

The following links might also be useful in your quest to understanding this issue:

1. [Stackoverflow - error failed to build gem native extension](http://stackoverflow.com/questions/13108299/error-installing-debugger-linecache-error-failed-to-build-gem-native-extension)
2. [github issue - debugger](https://github.com/cldwalker/debugger/issues/14)
3. [Keeping build directory after installation with rbenv](https://github.com/sstephenson/ruby-build#keeping-the-build-directory-after-installation).

### Compiling and deploying assets to Heroku:

(The following commands and rakes assume that you are already using asset_sync gem and that it is configured correctly):

1. Delete any assets found under the public folder: bundle exec rake assets:clean
2. Compile new assets to generate/update the manifest.yml: bundle exec rake assets:precompile:all RAILS_ENV=production , heroku needs the production environment. You can change this to development if you want to make a quick test. But be ware that you can not predict the full assets behaviour until you test it on the production. This command might take some time, so be patient. 
