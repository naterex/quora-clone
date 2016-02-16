# create#new
get "/questions/:question_id/answers/new" do
  @question = Question.find(params[:question_id])
  erb :"answers/answer_new"
end

# create#create
post "/questions/:question_id/answers/create" do
  puts "[LOG] Getting /answers/create"
  puts "[LOG] Params: #{params.inspect}"
  puts ""

  question = Question.find(params[:question_id])
  user = User.find(session[:user_id])
  answer = question.answers.new(content: params[:answer][:content], question_id: question.id, user_id: user.id)

  if answer.save
    user = answer.question.user # find user by who created question
    session[:notice] = "You created a new answer successfully."
    redirect "/users/#{user.id}/questions/#{question.id}"
  else
    session[:error] = answer.errors.full_messages.first
    redirect "/questions/#{question.id}/answers/new"
  end

end

# read#show
get "/questions/:question_id/answers/:id" do
  puts "[LOG] Getting /answers/:id"
  puts "[LOG] Params: #{params.inspect}"
  puts ""

  question = Question.find(params[:question_id])
  @answer = question.answers.find(params[:id])
  erb :"answers/answer"
end

# read#index through question
get "/questions/:question_id/answers" do
  puts "[LOG] Getting /answers/"
  puts "[LOG] Params: #{params.inspect}"
  puts ""

  question = Question.find(params[:question_id])
  @answers = question.answers.all

  @answers = @answers.sort_by{ |attribute| attribute[:id] }.reverse # show last added answer at top of list
  erb :"answers/answers"
end

# read#index through user
get "/users/:user_id/answers" do
  puts "[LOG] Getting /answers/"
  puts "[LOG] Params: #{params.inspect}"
  puts ""

  user = User.find(params[:user_id])
  @answers = user.answers.all

  @answers = @answers.sort_by{ |attribute| attribute[:id] }.reverse # show last added answer at top of list
  erb :"answers/answers"
end

# update#edit
get "/questions/:question_id/answers/:id/edit" do
  puts "[LOG] Getting /answers/:id/edit"
  puts "[LOG] Params: #{params.inspect}"
  puts ""

  question = Question.find(params[:question_id])
  @answer = question.answers.find(params[:id])
  erb :"answers/answer_edit"
end

# update#update
post "/questions/:question_id/answers/:id/update" do
  puts "[LOG] Getting /answers/:id/update"
  puts "[LOG] Params: #{params.inspect}"
  puts ""

  question = Question.find(params[:question_id])
  answer = question.answers.find(params[:id])
  @params = params[:answer]
  # byebug
  @params.each do |p|
    key = p[0].to_sym
    value = p[1]
    if value == ""
    else
      answer[key] = value
    end
  end

  if answer.save
    session[:notice] = "You edited the answer successfully."
    redirect "/users/#{question.user.id}/questions/#{question.id}"
  else
    session[:error] = answer.errors.full_messages.first
    redirect "/questions/#{question.id}/answers/#{answer.id}/edit"
  end
end

# delete#destroy
post "/users/:user_id/answers/:id/delete" do
  puts "[LOG] Getting /answers/:id/delete"
  puts "[LOG] Params: #{params.inspect}"
  puts ""

  user = User.find(params[:user_id])
  answer = user.answers.find(params[:id])
  answer.destroy

  if answer.destroyed?
    user = answer.question.user # find user by who created question
    session[:notice] = "You deleted the answer successfully."
    redirect "/users/#{user.id}/questions/#{answer.question.id}"
  else
    session[:error] = answer.errors.full_messages.first
    redirect "/questions/#{question.id}/answers/#{answer.id}/edit"
  end
end
