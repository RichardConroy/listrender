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
        s3_download_record.articles.create!(
          external_id: response_hash['id'],
          title: response_hash['title'],
          description: response_hash['description']
        )
      end
    end

    private

    attr_accessor :s3_download_record
  end
end
