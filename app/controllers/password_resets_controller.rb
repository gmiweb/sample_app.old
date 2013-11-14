class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    redirect_to root_url, :notice => 'Email sent with password reset instructions.'
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => 'Password reset has expired.'
    elsif update_user_password(@user,user_params)
      redirect_to new_session_path, :notice => 'Password has been reset!'
    else
      render :edit
    end
  end

  private

  # @param [User] The user to update
  # @param [Hash] Fields from form to update user.
  def update_user_password(user, attributes)
    user.update_attributes(attributes)
    # Need to save this because the update_attributes method fails on validation.
    user.save(:validate => false)
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
