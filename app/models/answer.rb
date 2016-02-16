class Answer < ActiveRecord::Base
  validates_presence_of :content, message: "Error: answer can't be blank."

  belongs_to :user
  belongs_to :question

end
