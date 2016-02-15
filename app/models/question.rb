class Question < ActiveRecord::Base
  validates_presence_of :content, message: "Error: question can't be blank."

  belongs_to :user

end
