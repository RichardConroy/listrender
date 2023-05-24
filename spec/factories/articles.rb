# frozen_string_literal: true

FactoryBot.define do
  factory :article do
    external_id { 1 }
    title { "MyString" }
    description { "MyString" }
    s3_download
  end
end
