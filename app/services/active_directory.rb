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
    @connection.add(:dn=>user.ldap_distinguished_name(user), :attributes=>ldap_attributes(user))
    result = @connection.get_operation_result
    logger.debug(result)
    return result
  end

  # Build account attributes
  protected
  def ldap_attributes(user)
    attributes = {
        :cn => user.human_name,
        :objectclass => ["top", "person", "organizationalPerson", "user"],
        :sn => user.last_name,
        :givenName => user.first_name,
        :displayName => user.human_name,
        :userPrincipalName =>user.email,
        :mail => user.email
    }
    return attributes
  end

  # Build user distinguished name for active directory account
  def ldap_distinguished_name(user)
    distinguished_name = "cn=#{user.human_name},"
    base_distinguished_name = "dc=cmusv,dc=sv,dc=cmu,dc=local"


    if user.is_staff
      distinguished_name+="ou=Staff,ou=Sync,"
    elsif !user.masters_program.blank?
      distinguished_name+= "ou="+user.masters_program+",ou=Students,ou=Sync,"
    else
      distinguished_name+="ou=Sync,"
    end

    distinguished_name+=base_distinguished_name
    logger.debug(distinguished_name)
    return distinguished_name
  end

end
