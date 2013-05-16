require 'net/ldap'

# This class establishes an encrypted connection to active directory, and authenticates users against active directory.
class LDAP

  # Configure parameters for an encrypted connection to LDAP server
  def self.configure
    # Get configurations from initialized ActiveDirectory class
    conn = Net::LDAP.new
    conn.host = LDAPConnection.host #LDAP host
    conn.port = LDAPConnection.port # 636 for SSL, 389 for non-SSL
    conn.encryption(:method=>:simple_tls) if LDAPConnection.is_encrypted?
    if !LDAPConnection.username.nil? && !LDAPConnection.password.nil?
      conn.auth LDAPConnection.username, LDAPConnection.password # Create a special account for these
    end
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

