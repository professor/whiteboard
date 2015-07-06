Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.max_attempts = 5

#Delayed::Worker.logger = Rails.logger

require 'person_job'
