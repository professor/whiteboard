This document lists down the steps to get the Ruby on Rails project (cmusv) up and going with a Virtual Machine.

# User Instructions (OSX) for getting the CMUSV environment up and running from the VM Box #

1. Clone the Rails repository

        git clone git@github.com:professor/cmusv.git

1. Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
1. Download and install [vagrant](http://vagrantup.com/)

        # or use the below command if you're comfortable with the terminal
        sudo gem install vagrant --no-ri --no-rdoc -V

1. Install cmusv custom VM box

        vagrant box add cmusv_professor vm_cmusv_professor.box

1. Setup vagrant config (alternatively we could have this also checked in to the github cmusv repo)

        # below steps create the Vagrant file on your own.
        vagrant init cmusv_professor

        # add/uncomment following lines in the generated VagrantFile
        config.vm.box = "cmusv_professor"
        config.vm.forward_port 3000, 3142
        # config.vm.provision :shell, :inline => "apt-get update --fix-missing"

1. CMUSV rails project specific project settings

        cp config/database.default.yml config/database.yml
            # see instructor for username and password
        cp config/morning_glory.mfse.yml config/morning_glory.yml
            # no need to configure
        cp config/systems.default.yml config/systems.yml
            # no need to configure
        cp config/amazon_s3.default.yml config/amazon_s3.yml
            # edit settings as mentioned in this page: http://rails.sv.cmu.edu/pages/amazon_s3.yml
        cp config/google_apps.default.yml config/google_apps.yml
            # edit settings as mentioned in this page: http://rails.sv.cmu.edu/pages/google_apps.yml


1. Start up the virtual machine

        vagrant up
        # will prompt you for your machine's admin password (for port forwarding rights)

1. (Windows users only)

    * Download and install [PuTTY & PuTTYGen](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html)

    * Run PuTTyGen to convert the private key to a PuTTY key
        * File -> Load private key and open the private key file mentioned by 'vagrant ssh'
        * Save private key

1. ssh into your VM
    * (Windows users only) Run PuTTY to SSH into the VM
        * Enter in the host 127.0.0.1 and port 2222 as provided by vagrant.
        * Under Connection -> Data enter vagrant for the auto-login username
        * Under Connection -> SSH -> Auth  Browse to the generated ppk key saved in the previous step
        * Under Session save the session settings
        * Open the session

    * (Non-Windows users)
        * vagrant ssh

1. Update apt-get to latest version

        sudo apt-get update --fix-missing

1. Load CMUSV project data

        cd /vagrant

        # you may have to change to a different directory, if you setup your repo clone and vagrant in a different subfolder. e.g:
        # cd /vagrant/cmusv

        # modify the db/seeds.rb and modify the example :your_name_here with your details. See step 12 on this page https://github.com/professor/cmusv/blob/master/CMUSV_Students.md

        bundle exec rake db:schema:load
        bundle exec rake db:setup
            # to load the seeds.rb data
        bundle exec rake RAILS_ENV="test" db:schema:load

1. Bring up the cmusv rails server

        bundle exec rails s thin

1. open http://localhost:3142 in your local browser.


# vagrant commands #

    vagrant ssh         # connect through ssh to the VM
    vagrant up          # start the VM
    vagrant halt        # stop the VM
    vagrant reload      # if you make vagrant changes, you can use the command to reload the VM
    vagrant status      # to find current status of VM
    vagrant package     # export the VM environment to a single file
    vagrant suspend
    vagrant resume
    vagrant destroy



# Creating the VM #

1. Install cmusv rails project (see [cmusv page](https://github.com/professor/cmusv/blob/master/CMUSV_Students.md))
1. Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
1. Download and install [vagrant](http://vagrantup.com/)
1. Add the Ubuntu Lucid (10.04) 32-bit VM vagrant box

        vagrant box add lucid32 http://files.vagrantup.com/lucid32.box

1. Initialize the Vagrant project

        vagrant init lucid32

1. setup vagrant config

        # add/uncomment following lines in the generated VagrantFile
        config.vm.forward_port 3000, 3142
        config.vm.provision :shell, :inline => "apt-get update --fix-missing"

1. bring up Vagrant VM

        vagrant up

1. ssh into the machine for setting up environment

        vagrant ssh
        cd /vagrant
        sudo apt-get upgrade
        sudo apt-get install build-essential zlib1g-dev curl git-core sqlite3 libsqlite3-dev

1. install ruby

        git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
        echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
        echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
        source ~/.bash_profile

        git clone git://github.com/sstephenson/ruby-build.git
        cd ruby-build/
        sudo ./install.sh
        rbenv install 1.9.2-p180
        rbenv rehash
        rbenv global 1.9.2-p180

1. get Rails running

        gem install bundler
        rbenv rehash
        bundle
        bundle exec rails s thin

1. CMUSV project specific settings

        # install postgres
        sudo apt-get install postgresql libpq-dev

        # database setup
        sudo -u postgres createuser --superuser cmusv_user
        sudo -u postgres createdb -O cmusv_user cmu_education
        sudo -u postgres createdb -O cmusv_user cmu_education_test

        sudo -u postgres psql -l
        # make sure database.yml populated appropriately
        sudo vi /etc/postgresql/8*/main/pg_hba.conf
        sudo vi /etc/postgresql/8*/main/pg_hba.conf
        sudo /etc/init.d/postgresql* reload


        sudo aptitude install imagemagick
        sudo aptitude install perlmagick
        sudo apt-get install libmagickwand-dev

        see [nokogiri page](http://nokogiri.org/tutorials/installing_nokogiri.html) and follow steps for Ubuntu

1. package the box for easy deployment

        vagrant package
        mv package.box vm_cmusv_professor.box



# References #

1. [railscast episode on vagrant](http://railscasts.com/episodes/292-virtual-machines-with-vagrant)