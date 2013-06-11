class LDAPConfig
  def self.host
    ENV['LDAP_HOST'] || '127.0.0.1'
  end

  def self.port
    ENV['LDAP_PORT'] || '636'
  end

  def self.username
    ENV['LDAP_USERNAME'] || 'anyone'
  end

  def self.password
    ENV['LDAP_PASSWORD'] || 'anysecret'
  end

  def self.is_encrypted?
    ENV['LDAP_ENCRYPTED'] || true
  end
end
