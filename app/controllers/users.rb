get "/users" do
  puts "[LOG] Getting /users"
  puts "[LOG] Params: #{params.inspect}"

  @users = User.all
  @users = @users.sort_by{ |attribute| attribute[:id] }.reverse # show last added user at top of list
  erb :"static/users"
end

post "/users/signup" do
  puts "[LOG] Getting /signup"
  puts "[LOG] Params: #{params.inspect}"
  @user = User.new(params[:user])

  if @user.save
    redirect "/users"
  else
    redirect "/"
  end

end
