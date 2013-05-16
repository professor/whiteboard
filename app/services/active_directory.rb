require 'net/ldap'

# This class provides active directory services

class ActiveDirectory

  # Initialize connection to active directory
  def self.initialize
    @connection = Net::LDAP.new(:host=>LDAPConfig.host, :port =>LDAPConfig.port)
    @connection.encryption(:method=>:simple_tls) unless !LDAPConfig.is_encrypted?
    @connection.auth LDAPConfig.username, LDAPConfig.password unless LDAPConfig.username.nil? || LDAPConfig.password.nil?
  end

  # Create user account in active directory
  def create_account(user)
    @connection.add(:dn=>user.ldap_distinguished_name, :attributes=>user.ldap_attributes)
    result = @connection.get_operation_result
    logger.debug(result)
    return result
  end
end
