require 'net/ldap'

# This class provides active directory services
class ActiveDirectory

  # Initialize connection to active directory
  def self.initialize
    @connection = Net::LDAP.new(:host=>LDAPConfig.host, :port =>LDAPConfig.port)
    @connection.encryption(:method=>:simple_tls) unless !LDAPConfig.is_encrypted?
    @connection.auth LDAPConfig.username, LDAPConfig.password unless LDAPConfig.username.nil? || LDAPConfig.password.nil?
  end

  # Create a user account in active directory
  # Return message as "Success", "Unwilling to perform", "Entity exists" or "No such object"
  def create_account(user)
    @connection.add(:dn=>user.ldap_distinguished_name(user), :attributes=>ldap_attributes(user))
    return @connection.get_operation_result.message
  end

  # Build attributes for active directory account
  # Code 512 creates standard user account and enables it
  def ldap_attributes(user)
    attributes = {
        :cn => user.human_name,
        :mail => user.email,
        :objectclass => ["top", "person", "organizationalPerson", "user"],
        :userPrincipalName =>user.email,
        :unicodePwd=> password_encode('Just4now' + Time.now.to_f.to_s[-4,4]),
        :userAccountControl=>"512",
        :sn => user.last_name,
        :givenName => user.first_name,
        :displayName => user.human_name
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
    return distinguished_name
  end

  # Convert password to unicode format
  def password_encode(password)
    result = ""
    password = "\"" + password + "\""
    password.length.times{|i| result+= "#{password[i..i]}\000" }
    result
  end
end
