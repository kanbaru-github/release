class Admin::PostsController < ApplicationController

  before_action :authenticate_admin!

  def index
    if params[:category_id]
      @category = Category.find(params[:category_id])
      all_posts = @category.posts
    else
      all_posts = Post.includes(:category)
    end
    @posts = all_posts.page(params[:page]).order(params[:sort])

    if params[:post].present?
      if params[:post].empty?
        @posts = all_posts.page(params[:page]).reverse_order.where.not(customer_id: params[:id])
      else
        @posts = Post.where('text LIKE(?)', "%#{params[:post][:keyword]}%")
      end
    else
      @posts = all_posts.page(params[:page]).reverse_order.where.not(customer_id: params[:id])
    end

    @all_posts_count = all_posts.count
    @categories = Category.all
  end

  def new
    @post = Post.new
    @categories = Category.all
  end

  def create
    @post = Post.new(post_params)
    @post.customer_id = current_customer.id

    if @post.save
      redirect_to posts_path, notice: '投稿しました！'
    else
      @categories = Category.all
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to mypage_path, notice: '更新しました！'
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_path
  end

  def search
    @posts = Post.where('text LIKE(?)', "%#{params[:keyword]}%")
    render :index
  end

  private

  def post_params
    params.require(:post).permit(:text, :category_id, :sympathies, :cheers)
  end

end

