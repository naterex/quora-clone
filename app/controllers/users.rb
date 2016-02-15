# create#new
get "/users/new" do
  erb :"static/signup"
end

# create#create
post "/users/signup" do
  puts "[LOG] Getting /users/signup"
  puts "[LOG] Params: #{params.inspect}"
  user = User.new(params[:user])

  if user.save
    session[:user_id] = user.id
    redirect "/users/#{user.id}"
  else
    redirect "/"
  end
end

# read#show
get "/users/:id" do
  puts "[LOG] Getting /users/:id"
  puts "[LOG] Params: #{params.inspect}"
  # @user = User.find(params[:id])
  @user = current_user()
  erb :"static/user"
end

# read#index
get "/users" do
  puts "[LOG] Getting /users"
  puts "[LOG] Params: #{params.inspect}"

  @users = User.all
  @users = @users.sort_by{ |attribute| attribute[:id] }.reverse # show last added user at top of list
  erb :"static/users"
end


# NOT COMPLETE
# update#edit
get "/users/:id/edit" do
  puts "[LOG] Getting /users/edit/:id"
  puts "[LOG] Params: #{params.inspect}"
  @user = User.find(params[:user][:id])

  erb :"static/user_edit"
end

# NOT COMPLETE
# update#update
patch "/users/:id/update" do
  puts "[LOG] Getting /users/update"
  puts "[LOG] Params: #{params.inspect}"

  user = User.find(params[:user][:id])

  if user.save?
    redirect "/users/#{user.id}"
  else
    redirect "/users/edit"
  end
end

# NOT COMPLETE
# delete#destroy
delete "/users/:id/delete" do
  puts "[LOG] Getting /users/"
  puts "[LOG] Params: #{params.inspect}"

  user = User.find(params[:user][:id])
  user.destroy

  if user.destroyed?
    redirect "/users/logout"
  else
    redirect "/users/edit"
  end
end

# login
post "/users/login" do
  puts "[LOG] Getting /users/login"
  puts "[LOG] Params: #{params.inspect}"
  user = User.authenticate(params[:user][:email], params[:user][:password])

  if user
    # byebug
    session[:user_id] = user.id
    redirect "/"
    # redirect "/users/#{user.id}" # correct to use redirect to pass users/:id method?
  else
    redirect "/"
  end
end

# logout
post "/users/logout" do
  # session[:user_id] = nil # can also use this to clear session
  session.clear
  redirect "/"
end
