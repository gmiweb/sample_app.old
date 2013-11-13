class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(username: params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      sign_in user    # Calling sign_in method from sessions_helper.rb
      redirect_back_or user  # Calling method from sessions_helper
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out # Calling sessions_helper.rb method.
    redirect_to root_url
  end
end