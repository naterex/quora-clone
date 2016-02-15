get '/' do
  @questions = Question.all

  if logged_in?
    @user = current_user()
    # erb :"static/questions"
    erb :"questions/questions"
  else
    erb :"static/index"
  end

end
