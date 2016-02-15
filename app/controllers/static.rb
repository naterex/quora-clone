get '/' do
  @question = Question.all
  # erb :"static/questions"
  erb :"static/index"
end
