require 'net/ldap'

# This class establishes an encrypted connection to active directory, and authenticates users against active directory.
class Ldap

  # Configure parameters for an encrypted connection to LDAP server
  def self.configure
    # Get configurations from initialized ActiveDirectory class
    conn = Net::LDAP.new
    conn.host = ActiveDirectory.host #LDAP host
    conn.port = 636 # 636 for SSL, 389 for non-SSL
    conn.encryption(:method=>:simple_tls)
    conn.auth ActiveDirectory.username, ActiveDirectory.password # Create a special account for this
    return conn
  end

  # Authenticate against active directory, time out after N seconds, return true or false
  def self.authenticate
    begin
      Timeout::timeout(10) do
        return (self.configure.bind) ? true : false
      end
    rescue Timeout::Error
      return false
    end
  end
end

