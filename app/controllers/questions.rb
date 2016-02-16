# create#new
get "/users/:user_id/questions/new" do
  @user = current_user()
  erb :"questions/question_new"
end

# create#create
post "/users/:user_id/questions/create" do
  puts "[LOG] Getting /questions/create"
  puts "[LOG] Params: #{params.inspect}"
  puts ""

  user = current_user()
  question = user.questions.new(content: params[:question][:content], user_id: user.id)

  if question.save
    redirect "/users/#{user.id}/questions"
  else
    redirect "/users/#{user.id}/questions/new"
  end

end

# read#show
get "/users/:user_id/questions/:id" do
  puts "[LOG] Getting /questions/:id"
  puts "[LOG] Params: #{params.inspect}"
  puts ""

  erb :"questions/question"
end

# read#index
get "/users/:user_id/questions" do
  puts "[LOG] Getting /questions/"
  puts "[LOG] Params: #{params.inspect}"
  puts ""

  @questions = Question.all
  @questions = @questions.sort_by{ |attribute| attribute[:id] }.reverse # show last added question at top of list
  erb :"questions/questions"
end

# update#edit
get "/users/:user_id/questions/:id/edit" do
  puts "[LOG] Getting /questions/:id/edit"
  puts "[LOG] Params: #{params.inspect}"
  puts ""

  erb :"questions/question_edit"
end

# update#update
patch "/users/:user_id/questions/:id/update" do
  puts "[LOG] Getting /questions/:id/update"
  puts "[LOG] Params: #{params.inspect}"
  puts ""

end

# delete#destroy
post "/users/:user_id/questions/:id/delete" do
  puts "[LOG] Getting /questions/:id/delete"
  puts "[LOG] Params: #{params.inspect}"
  puts ""

end
