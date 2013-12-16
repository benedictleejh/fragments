class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable, :trackable, 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :stories, foreign_key: :creator_id
  has_many :fragments, foreign_key: :author_id
  
  validates :username, presence: true, length: { minimum: 2 }, uniqueness: { case_sensitive: false }

  before_validation :clear_whitespace

  # Allow login using case insensitive username, but save case senstive username in DB
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if username = conditions.delete(:username)
      where(conditions).where(["lower(username) = :value", { :value => username.downcase }]).first
    else
      where(conditions).first
    end
  end
  
  def clear_whitespace
    self.username.delete!(' ')
  end
end
