# create#new
get "/users/new" do
  erb :"users/signup"
end

# create#create
post "/users/signup" do
  puts "[LOG] Getting /users/signup"
  puts "[LOG] Params: #{params.inspect}"
  puts ""
  user = User.new(params[:user])

  if user.save
    session[:user_id] = user.id
    session[:notice] = "You signed up successfully."
    redirect "/users/#{user.id}"
  else
    session[:error] = user.errors.full_messages.first
    redirect "/users/new"
  end
end

# read#show
get "/users/:id" do
  puts "[LOG] Getting /users/:id"
  puts "[LOG] Params: #{params.inspect}"
  puts ""

  @user = current_user()
  erb :"users/user"
end

# read#index
get "/users" do
  puts "[LOG] Getting /users"
  puts "[LOG] Params: #{params.inspect}"
  puts ""

  @users = User.all
  @users = @users.sort_by{ |attribute| attribute[:id] }.reverse # show last added user at top of list
  erb :"users/users"
end

# update#edit
get "/users/:id/edit" do
  puts "[LOG] Getting /users/:id/edit"
  puts "[LOG] Params: #{params.inspect}"
  puts ""

  @user = User.find(params[:id])
  erb :"/users/user_edit"
end

# update#update
post "/users/:id/update" do
  puts "[LOG] Getting /users/:id/update"
  puts "[LOG] Params: #{params.inspect}"
  puts ""

  user = User.find(params[:id])
  @params = params[:user]

  @params.each do |p|
    key = p[0].to_sym
    value = p[1]
    if value == ""
    else
      user[key] = value
    end
  end

  if user.save
    session[:notice] = "You edited your info successfully."
    redirect "/users/#{user.id}"
  else
    session[:error] = user.errors.full_messages.first
    redirect "/users/#{user.id}/edit"
  end
end

# delete#destroy
post "/users/:id/delete" do
  puts "[LOG] Getting /users/:id/delete"
  puts "[LOG] Params: #{params.inspect}"
  puts ""

  user = User.find(params[:id])
  user.destroy

  if user.destroyed?
    session.clear
    session[:notice] = "You signed deleted your account successfully."
    redirect "/"
  else
    session[:error] = user.errors.full_messages.first
    redirect "/users/#{user.id}/edit"
  end
end

# login
post "/users/login" do
  puts "[LOG] Getting /users/login"
  puts "[LOG] Params: #{params.inspect}"
  puts ""

  user = User.authenticate(params[:user][:email], params[:user][:password])

  if user
    session[:user_id] = user.id
    session[:notice] = "You logged in successfully."
    redirect "/"
  else
    redirect "/"
  end
end

# logout
post "/users/logout" do
  puts "[LOG] Getting /users/logout"
  puts ""

  # session.clear # can also use this to clear session
  session[:user_id] = nil
  session[:notice] = "You logged out successfully."

  redirect "/"
end
