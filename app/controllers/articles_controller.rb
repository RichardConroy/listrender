# frozen_string_literal: true

# Controller class for rendering collections of articles from an external YAML file stored on S3
class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]

  # GET /articles or /articles.json
  def index
    # @articles = Article.all
    data_source_url = 'https://s3-eu-west-1.amazonaws.com/olio-staging-images/developer/test-articles-v4.json'
    faraday_connection = Faraday.new(data_source_url) do |connection|
      # connection.request :retry
      connection.response :json
    end

    json_response = faraday_connection.get
    @articles = json_response.body.map do |response_hash|
      Article.new external_id: response_hash['id'], title: response_hash['title'], description: response_hash['description']
    end
  end

  def like

  end

  # GET /articles/1 or /articles/1.json
  def show
    # TODO: scaffold boilerplace - review if needed
  end

  # GET /articles/new
  def new
    # TODO: scaffold boilerplace - review if needed
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
    # TODO: scaffold boilerplace - review if needed
  end

  # POST /articles or /articles.json
  def create
    # TODO: scaffold boilerplace - review if needed
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(@article), notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    # TODO: scaffold boilerplace - review if needed
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    # TODO: scaffold boilerplace - review if needed
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_article
    # TODO: scaffold boilerplace - review if needed
    @article = Article.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def article_params
    # TODO: scaffold boilerplace - review if needed
    params.fetch(:article, {})
  end
end
