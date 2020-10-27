module RandomToken
  def generate_base58_token(column, length=ActiveSupport::MessageEncryptor.key_len)
    loop do
      self[column] = SecureRandom.base58(length)
      break unless self.class.exists?(column => self[column])
    end
  end

  def generate_base64_token(column, length=ActiveSupport::MessageEncryptor.key_len)
    loop do
      self[column] = SecureRandom.urlsafe_base64(length)

      break unless self.class.exists?(column => self[column])
    end
  end

  def generate_hex_token(column, length=ActiveSupport::MessageEncryptor.key_len)
    loop do
      self[column] = SecureRandom.hex(length)

      break unless self.class.exists?(column => self[column])
    end
  end
end
