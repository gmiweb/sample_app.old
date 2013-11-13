class UsersController < ApplicationController
  # forces users to be signed in iff edit and update action.
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy,
                                        :followers, :following]
  before_action :correct_user, only: [:edit, :update] # checks if user eq. to current_user
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    # Do not let a signed in user create another user.
    if signed_in?
      redirect_to root_url
    end

    @user = User.new
  end

  def create
    # Do not let a signed in user create another user.
    if signed_in?
      redirect_to root_url
    end

    @user = User.new(user_params)
    if @user.save
      #calling sign_in from sessions_helper.rb. This is global because of
      # the ApplicationController including it for everyone.
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    #current_user is already an admin otherwise he would not make it to this point.
    if current_user != user
      user.destroy
      flash[:success] = "User deleted."
      redirect_to users_url
    else
      redirect_to(root_url)
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def user_params
    params.require(:user).permit(:name, :username, :email, :password,
                                 :password_confirmation)
  end

  # Before filters

  def correct_user
    @user = User.find(params[:id]) # This is the user they are requesting to update.
    redirect_to(root_url) unless current_user?(@user) # Check this against who is currently signed in.
  end

  def admin_user
    # Need to check if current_user is user being deleted. Do not allow.
    redirect_to(root_url) unless current_user.admin?
  end

end
