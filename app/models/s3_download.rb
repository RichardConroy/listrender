# frozen_string_literal: true

# ActiveRecord to store the JSON locally for the articles list
class S3Download < ApplicationRecord
  has_many :articles
  validates :manifest, presence: true
end
