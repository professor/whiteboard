#!/bin/sh

bundle exec rake db:reset RAILS_ENV="test"
bundle exec rake db:setup RAILS_ENV="test"
bundle exec rake db:test:load
rspec spec/
