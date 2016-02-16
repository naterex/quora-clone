# create#new
get "/users/:user_id/questions/new" do
  @user = User.find(params[:user_id])
  erb :"questions/question_new"
end

# create#create
post "/users/:user_id/questions/create" do
  puts "[LOG] Getting /questions/create"
  puts "[LOG] Params: #{params.inspect}"
  puts ""

  user = User.find(params[:user_id])
  question = user.questions.new(content: params[:question][:content], user_id: user.id)

  if question.save
    session[:notice] = "You created a new question successfully."
    redirect "/users/#{user.id}/questions"
  else
    session[:error] = question.errors.full_messages.first
    redirect "/users/#{user.id}/questions/new"
  end

end

# read#show
get "/users/:user_id/questions/:id" do
  puts "[LOG] Getting /questions/:id"
  puts "[LOG] Params: #{params.inspect}"
  puts ""

  user = User.find(params[:user_id])
  @question = user.questions.find(params[:id])
  erb :"questions/question"
end

# read#index
get "/users/:user_id/questions" do
  puts "[LOG] Getting /questions/"
  puts "[LOG] Params: #{params.inspect}"
  puts ""

  user = User.find(params[:user_id])
  @questions = user.questions.all

  @questions = @questions.sort_by{ |attribute| attribute[:id] }.reverse # show last added question at top of list
  @index_title = "My Questions"
  erb :"questions/questions"
end

# update#edit
get "/users/:user_id/questions/:id/edit" do
  puts "[LOG] Getting /questions/:id/edit"
  puts "[LOG] Params: #{params.inspect}"
  puts ""

  user = User.find(params[:user_id])
  @question = user.questions.find(params[:id])
  erb :"questions/question_edit"
end

# update#update
post "/users/:user_id/questions/:id/update" do
  puts "[LOG] Getting /questions/:id/update"
  puts "[LOG] Params: #{params.inspect}"
  puts ""

  user = User.find(params[:user_id])
  question = user.questions.find(params[:id])
  @params = params[:question]
  # byebug
  @params.each do |p|
    key = p[0].to_sym
    value = p[1]
    if value == ""
    else
      question[key] = value
    end
  end

  if question.save
    session[:notice] = "You edited the question successfully."
    redirect "/users/#{user.id}/questions/#{question.id}"
  else
    session[:error] = question.errors.full_messages.first
    redirect "/users/#{user.id}/questions/#{question.id}/edit"
  end
end

# delete#destroy
post "/users/:user_id/questions/:id/delete" do
  puts "[LOG] Getting /questions/:id/delete"
  puts "[LOG] Params: #{params.inspect}"
  puts ""

  user = User.find(params[:user_id])
  question = user.questions.find(params[:id])
  question.destroy

  if question.destroyed?
    session[:notice] = "You deleted the question successfully."
    redirect "/users/#{user.id}/questions"
  else
    session[:error] = question.errors.full_messages.first
    redirect "/users/#{user.id}/questions/#{question.id}/edit"
  end
end
