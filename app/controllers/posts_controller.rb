class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def new
    @post = current_user.posts.build if user_signed_in?
  end

  def show
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Image Upload!"
      redirect_to @post
    else
      render 'pages/home'
    end
  end

  def destroy
    @post.destroy
    flash[:success] = "Post delete"
    redirect_to current_user
  end

  private

    def post_params
      params.require(:post).permit(:user_id,:content,:image)
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end

end
