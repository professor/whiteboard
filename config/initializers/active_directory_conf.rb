
# This file initializes active directory configuration using parameters from active_directory.yml during initialization
CONFIG = YAML.load_file("#{Rails.root}/config/active_directory.yml")[Rails.env]

class LDAPConnection
  # Return active host
  def self.host
    CONFIG['host']
  end
  # Return active port
  def self.port
    CONFIG['port']
  end
  # Return active user name
  def self.username
    CONFIG['username']
  end
  # Return active password
  def self.password
    CONFIG['password']
  end
  # Return true if connection is encrypted
  def self.is_encrypted?
    CONFIG['encrypted']
  end
end
