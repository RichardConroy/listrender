# frozen_string_literal: true

FactoryBot.define do
  factory :s3_download do
    manifest { JSON.parse(File.open(%W[#{Rails.root} spec fixtures files two_articles.json].join('/')).read) }

    trait :with_articles do
      after(:create) do |factory_instance|
        Manifest::Sync.call(s3_download_record: factory_instance)
      end
    end
  end
end
