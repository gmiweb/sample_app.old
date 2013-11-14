class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    #Get the content and check if @ exists at begining. If it does, then lookup username
    #set in_reply_to user id and save post.
    @micropost = current_user.microposts.build(micropost_params)
    if username = @micropost.content[/\A@(\w+)/] # in reply to...
      reply_to_user = User.find_by_username username.sub '@', ''
       @micropost.in_reply_to = reply_to_user ? reply_to_user.id : nil
    end
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content)
  end

  def correct_user
    # find throws exception if no microposts are found where as
    # find_by only returns nil.  Here we use exception handling.
    @micropost = current_user.microposts.find(params[:id])
  rescue
    redirect_to root_url
  end
end