# frozen_string_literal: true

module Manifest
  # Service class to download the most recent JSON for the article list and save it locally
  class Fetcher
    class << self
      def call
        new.call
      end
    end

    def call
      data_source_url = 'https://s3-eu-west-1.amazonaws.com/olio-staging-images/developer/test-articles-v4.json'
      faraday_connection = Faraday.new(data_source_url) do |connection|
        connection.response :json
      end

      json_response = faraday_connection.get
      S3Download.create! manifest: json_response.body # TODO: on error return last good S3Download
    end
  end
end
