# frozen_string_literal: true

# Controller class for rendering collections of articles from an external YAML file stored on S3
class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show like]
  before_action :download_s3_manifest, only: :index

  # GET /articles or /articles.json
  def index
    @articles = @created_s3_download.articles
  end

  def like
    @article.likes.create!
    redirect_to articles_url
  end

  # GET /articles/1 or /articles/1.json
  def show
    # TODO: scaffold boilerplace - review if needed
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_article
    # TODO: scaffold boilerplace - review if needed
    @article = Article.find(params[:id])
  end

  def download_s3_manifest
    @created_s3_download = Manifest::Fetcher.call
  end
end
