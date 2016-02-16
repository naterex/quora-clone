get '/' do

  @questions = Question.all
  @index_title = "Top Questions"
  erb :"questions/questions"

end
