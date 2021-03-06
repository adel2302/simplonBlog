class ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :destroy]
  before_action :check_is_admin, only: [:new, :edit, :destroy]
  before_action :set_article, only: [:show, :edit, :update, :destroy, :upvote, :downvote]

  # GET /articles
  # GET /articles.json
  def index
    if params[:tag] && current_user != "admin"
      @articles = Article.order(created_at: :desc).page(params[:page]).per(4).tagged_with(params[:tag])
    else
      if user_signed_in? && current_user.role == "admin"
        @q = Article.ransack(params[:q])
        @articles = @q.result.order(created_at: :desc)
      else
        @articles = Article.order(created_at: :desc).page(params[:page]).per(10)
      end
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update

    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to articles_url, notice: 'Article was successfully update.' }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def check_is_admin
   if current_user.role != "admin"
      redirect_to articles_url
   end
  end

  def upvote
    @article.upvote_by current_user
    redirect_to :back
  end

  def downvote
   @article.downvote_by current_user
   redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :content, :published, :image, :tag_list)
    end
end
