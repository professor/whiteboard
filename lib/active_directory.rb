require 'net/ldap'

# This class provides active directory services
class ActiveDirectory


  #
  # Creates an Active Directory account for the user
  # If this fails, it returns an error message as a string, else it returns true
  #
  def create_active_directory_account(user)
    # reject blank emails
    return "Empty email address" if user.email.blank?

    # log what is happening
    Rails.logger.debug("Attempting to create active directory account for " + user.email)

    # extract domain from email
    domain = user.email.split('@')[1]

    # Confirm domain name accuracy
    if domain != GOOGLE_DOMAIN
      Rails.logger.debug("Domain (" + domain + ") is not the same as the google domain (" + GOOGLE_DOMAIN)
      return "Domain (" + domain + ") is not the same as the google domain (" + GOOGLE_DOMAIN + ")"
    end

    # Attempt to create active directory account
    active_directory_service = ActiveDirectory.new
    if active_directory_service.create_account(user) == "Success"
      user.active_directory_account_created_at = Time.now()
      user.save
    end
  end


  # Initialize connection to active directory
  def initialize
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

  # Create a user account in active directory
  # Return message as "Success", "Unwilling to perform", "Entity exists" or "No such object"
  def create_account(user)
    if self.bind
      @connection.add(:dn => user.ldap_distinguished_name(user), :attributes => ldap_attributes(user))
      return @connection.get_operation_result.message
    else
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
    self.password_reset_sent_at = Time.zone.now
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
