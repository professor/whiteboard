require 'net/ldap'

# This class provides active directory services
class ActiveDirectory

  # Create an Active Directory account for a user
  # Error out if user's email address is blank or domain is not Google domain
  # If this fails, return an error message as a string, else return void
  # The return message is "Success", "Unwilling to perform", "Entity exists", "No such object", "Could not bind to server"
  def create_account(user)
    return "Empty email address" if user.email.blank?

    domain = user.email.split('@')[1]
    if domain != GOOGLE_DOMAIN
      return "Domain (" + domain + ") is not the same as the google domain (" + GOOGLE_DOMAIN + ")"
    end

    if self.bind
      @connection.add(:dn => user.ldap_distinguished_name(user), :attributes => ldap_attributes(user))

      message = @connection.get_operation_result.message
      if message == "Success"
        user.active_directory_account_created_at=Time.now()
        user.save
      else
        return message
      end

    else
      return "Could not bind to active directory server."
    end
  end


  # Initialize connection to active directory
  def self.initialize
    @connection = Net::LDAP.new(:host => LDAPConfig.host, :port => LDAPConfig.port)
    @connection.encryption(:method => :simple_tls) unless !LDAPConfig.is_encrypted?
    @connection.auth LDAPConfig.username, LDAPConfig.password unless LDAPConfig.username.nil? || LDAPConfig.password.nil?
  end

  # Attempt to bind to active directory, time out after N seconds, return true or false
  def bind
    return false unless !@connection.nil?
    begin
      Timeout::timeout(10) do
        return (@connection.bind) ? true : false
      end
    rescue Timeout::Error
      return false
    end
  end

  # Build attributes for active directory account
  # Code 512 creates standard user account and enables it
  def ldap_attributes(user)
    attributes = {
        :cn => user.human_name,
        :mail => user.email,
        :objectclass => ["top", "person", "organizationalPerson", "user"],
        :userPrincipalName => user.email,
        :unicodePwd => password_encode('Just4now' + Time.now.to_f.to_s[-4, 4]),
        :userAccountControl => "512",
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
      distinguished_name += "ou=Staff,ou=Sync,"
    elsif !user.masters_program.blank?
      distinguished_name += "ou=" + user.masters_program + ",ou=Students,ou=Sync,"
    else
      distinguished_name += "ou=Sync,"
    end

    distinguished_name += base_distinguished_name
    return distinguished_name
  end

  # Convert password to unicode format
  def password_encode(password)
    result = ""
    password = "\"" + password + "\""
    password.length.times { |i| result+= "#{password[i..i]}\000" }
    return result
  end

  # Send active directory password reset token
  def send_password_reset_token(user)
    user.set_password_reset_token
    user.password_reset_sent_at = Time.zone.now
    user.save!
    PasswordMailer.password_reset(user).deliver
  end

  # Reset active directory password
  def reset_password(user, new_pass)
    if self.bind
      distinguished_name = ldap_distinguished_name(user)
      @connection.replace_attribute distinguished_name, :unicodePwd, password_encode(new_pass)
      return @connection.get_operation_result.message
    else
      return false
    end
  end
end
