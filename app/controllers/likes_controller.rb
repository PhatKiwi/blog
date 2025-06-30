class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @like = @post.likes.build(user: current_user)
    
    if @like.save
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("like_button_#{@post.id}", partial: "likes/button", locals: { post: @post }) }
        format.html { redirect_back(fallback_location: @post) }
      end
    else
      redirect_back(fallback_location: @post)
    end
  end

  def destroy
    @like = @post.likes.find_by(user: current_user)
    @like&.destroy
    
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("like_button_#{@post.id}", partial: "likes/button", locals: { post: @post }) }
      format.html { redirect_back(fallback_location: @post) }
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
