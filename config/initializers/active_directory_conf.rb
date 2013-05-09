
# This file initializes active directory configuration using parameters from active_directory.yml during initialization
CONFIG = YAML.load_file("#{Rails.root}/config/active_directory.yml")[Rails.env]

class ActiveDirectory
  # Return active host
  def self.host
    CONFIG['host']
  end
  # Return active user name
  def self.username
    CONFIG['username']
  end
  # Return active password
  def self.password
    CONFIG['password']
  end
end
