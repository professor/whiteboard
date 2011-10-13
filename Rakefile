require File.expand_path('../config/application', __FILE__)
require 'rake'

# TODO: see if this code is still required to make rake work in 1.9.2
class Rails::Application
  include Rake::DSL if defined?(Rake::DSL)
end

CMUEducation::Application.load_tasks
