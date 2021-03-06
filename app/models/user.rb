class User < SQLObject
  has_many :tasks
  finalize!

  def self.find_by_credentials(username, password)
  	user = User.find_by(username: username)
  	user if user && user.valid_password?(password)
  end

  attr_reader :password

  def password=(password)
  	self.password_digest = BCrypt::Password.create('password')
  end

  def valid_password?(password)
  	BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def reset_session_token!
    token = SecureRandom.urlsafe_base64
  	self.update(session_token: token)
    token
  end

end