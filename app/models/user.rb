class User < ActiveRecord::Base
  validates_presence_of :name, message: "error: name can't be blank."
  validates_presence_of :email, message: "error: email can't be blank."
  validates_uniqueness_of :email, message: "error: email has already been used."
  validates_format_of :email, with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "error: incorrect email format."
  has_secure_password

  has_many :questions, dependent: :destroy
  # has_many :answers, dependent: :destroy
  # has_many :votes_questions, dependent: :destroy
  # has_many :votes_answers, dependent: :destroy

  def self.authenticate(email, password)
    @user = User.find_by(email: email)

    if @user && @user.authenticate(password)
      return @user
    else
      return false
    end
  end

end
