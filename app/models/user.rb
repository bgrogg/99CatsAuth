# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#


class User < ActiveRecord::Base
  validates :username, :password_digest, :session_token, presence: true
  validates :username, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }

  has_many :cats,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: "Cat"

  attr_reader :password
  after_initialize :ensure_session_token

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64(128)
    self.save!
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
    @password = password
  end

  def is_password?(password)
    bc_obj = BCrypt::Password.new(password_digest)
    bc_obj.is_password?(password)
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64(128)
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(username: user_name)
    return nil if user.nil?

    user.is_password?(password) ? user : nil
  end

end
