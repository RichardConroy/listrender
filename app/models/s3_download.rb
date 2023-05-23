# frozen_string_literal: true

# ActiveRecord to store the JSON locally for the articles list
class S3Download < ApplicationRecord
  validates :manifest, presence: true
end
