# frozen_string_literal: true

class ArticlesWithLikeCount
  class << self
    def call(s3_download_record: S3Download.last)
      new(s3_download_record: s3_download_record).call
    end
  end

  def initialize(s3_download_record:)
    @s3_download_record = s3_download_record
  end

  def call
    Article.select('articles.*, COUNT(likes.id) as like_count').where(s3_download_id: s3_download_record.id)
      .joins('LEFT OUTER JOIN likes ON (likes.article_id = articles.id)')
      .group('articles.id')
         # .joins('LEFT OUTER JOIN likes ON (likes.article_id = articles.id)')

  end

  private

  attr_accessor :s3_download_record
end
