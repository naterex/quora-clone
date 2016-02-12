
class User < ActiveRecord::Base
  validates_presence_of :name, message: "Error: name can't be blank."
  validates_presence_of :email, message: "Error: email can't be blank."
  validates_uniqueness_of :email, message: "Error: email has already been used."
  validates_format_of :email, with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "Error: incorrect email format."
  has_secure_password

end
