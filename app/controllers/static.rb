get '/' do
  @questions = Question.all

  if logged_in?
    @user = current_user()
    erb :"questions/questions"
  else
    erb :"questions/questions"
  end

end
