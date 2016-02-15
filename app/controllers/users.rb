require 'byebug'

get "/users" do
  puts "[LOG] Getting /users"
  puts "[LOG] Params: #{params.inspect}"

  @users = User.all
  @users = @users.sort_by{ |attribute| attribute[:id] }.reverse # show last added user at top of list
  erb :"static/users"
end

get "/users/new" do
  erb :"static/signup"
end


get "/users/:id" do
  puts "[LOG] Getting /users/:id"
  puts "[LOG] Params: #{params.inspect}"
  # @user = User.find(params[:id])
  @user = current_user
  erb :"static/user"
end

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

post "/users/login" do
  puts "[LOG] Getting /users/login"
  puts "[LOG] Params: #{params.inspect}"
  user = User.authenticate(params[:user][:email], params[:user][:password])

  if user
    # byebug
    session[:user_id] = user.id
    redirect "/users/#{user.id}" # correct to use redirect to pass users/:id method?
  else
    redirect "/"
  end
end

post "/users/logout" do
  # session[:user_id] = nil
  session.clear
  redirect "/"
end
