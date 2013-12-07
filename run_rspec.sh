#!/bin/sh


bundle exec rake db:reset RAILS_ENV="test" || echo "rake db:reset failed"
bundle exec rake db:setup RAILS_ENV="test"|| echo "rake db:setup failed"

bundle exec rake db:test:load || echo "rake db:test:load failed"

bundle exec rspec spec/ || echo "rake rspec spec failed"

