class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_comment, only: [:destroy]
  before_action :set_post

  def index
    @comments = Comment.all
  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = @post.comments.create(comment_params)
    @comment.user_id = current_user.id

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @post, notice: 'Comment was successfully created.' }
      else
        flash.now[:alert] = 'Error creating comment.'
      end
    end
  end

  def destroy
    @comment.destroy
    redirect_to @post, notice: 'Comment was successfully destroyed.'
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :post_id, :user_id)
  end
end
