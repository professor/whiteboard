# This file initializes active directory configuration using parameters from active_directory.yml during initialization
CONFIG = YAML.load_file("#{Rails.root}/config/active_directory.yml")[Rails.env]

class LDAPConfig
  def self.host
    CONFIG['host']
  end

  def self.port
    CONFIG['port']
  end

  def self.username
    CONFIG['username']
  end

  def self.password
    CONFIG['password']
  end

  def self.is_encrypted?
    CONFIG['encrypted']
  end
end
