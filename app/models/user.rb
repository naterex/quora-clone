
class User < ActiveRecord::Base
  validates_presence_of :name, message: "Error: name can't be blank."
  validates_presence_of :email, message: "Error: email can't be blank."
  validates_uniqueness_of :email, message: "Error: email has already been used."
  validates_format_of :email, with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "Error: incorrect email format."
  has_secure_password

  # users.password_hash in the database is a :string
  attr_accessor :password, :password_confirmation

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  # assign them a random one and mail it to them, asking them to change it
  def forgot_password
    @user = User.find_by_email(params[:email])
    random_password = Array.new(10).map { (65 + rand(58)).chr }.join
    @user.password = random_password
    @user.save!
    Mailer.create_and_deliver_password_change(@user, random_password)
  end

end
