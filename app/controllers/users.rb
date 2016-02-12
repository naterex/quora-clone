post "/signup" do
  user = User.new(params[:user])

  if user.save
    redirect "/users/:user_id"
  else
    status 400
    redirect "/"
  end

end
