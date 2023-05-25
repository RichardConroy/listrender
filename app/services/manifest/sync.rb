# frozen_string_literal: true

module Manifest
  # Service class to create local article entries for each article in a downloaded manifest
  class Sync
    class << self
      def call(s3_download_record:)
        new(s3_download_record: s3_download_record).call
      end
    end

    def initialize(s3_download_record:)
      @s3_download_record = s3_download_record
    end

    def call
      s3_download_record.manifest.map do |response_hash|
        article = Article.find_or_initialize_by(external_id: response_hash['id'])
        article.update!(
          external_id: response_hash['id'],
          title: response_hash['title'],
          description: response_hash['description'],
          s3_download_id: s3_download_record.id
        )
      end
    end

    private

    attr_accessor :s3_download_record
  end
end
