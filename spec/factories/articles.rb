FactoryBot.define do
  factory :article do
    external_id { 1 }
    title { "MyString" }
    description { "MyString" }
    s3_downloads { nil }
  end
end
