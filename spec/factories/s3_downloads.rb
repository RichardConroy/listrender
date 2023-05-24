# frozen_string_literal: true

FactoryBot.define do
  factory :s3_download do
    manifest { JSON.parse(File.open(%W[#{Rails.root} spec fixtures files two_articles.json].join('/')).read) }
  end
end
