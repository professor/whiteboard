require 'openssl'
require "base64"

module AESCrypt
  # Decrypts a block of data (encrypted_data) given an encryption key
  # and an initialization vector (iv).  Keys, iv's, and the data 
  # returned are all binary strings.  Cipher_type should be
  # "AES-256-CBC", "AES-256-ECB", or any of the cipher types
  # supported by OpenSSL.  Pass nil for the iv if the encryption type
  # doesn't use iv's (like ECB).
  #:return: => String
  #:arg: encrypted_data => String 
  #:arg: key => String
  #:arg: iv => String
  #:arg: cipher_type => String

  KEY = YAML.load_file("#{Rails.root}/config/aes_key.yml")[Rails.env]['key']
  CIPHER_TYPE = YAML.load_file("#{Rails.root}/config/aes_key.yml")[Rails.env]['cipher_type']

  def decrypt(encrypted_data, iv)
    aes = OpenSSL::Cipher::Cipher.new(CIPHER_TYPE)
    aes.decrypt
    aes.key = KEY
    aes.iv = iv if !iv.nil?

    aes.update(Base64.decode64(encrypted_data)) + aes.final
  end

  # Encrypts a block of data given an encryption key and an 
  # initialization vector (iv).  Keys, iv's, and the data returned 
  # are all binary strings.  Cipher_type should be "AES-256-CBC",
  # "AES-256-ECB", or any of the cipher types supported by OpenSSL.  
  # Pass nil for the iv if the encryption type doesn't use iv's (like
  # ECB).
  #:return: => String
  #:arg: data => String 
  #:arg: key => String
  #:arg: iv => String
  #:arg: cipher_type => String  
  def encrypt(data, iv)
    aes = OpenSSL::Cipher::Cipher.new(CIPHER_TYPE)
    aes.encrypt
    aes.key = KEY
    aes.iv = iv if !iv.nil?
    Base64.encode64(aes.update(data) + aes.final)
  end
end