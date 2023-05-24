# frozen_string_literal: true

# Model for storing a local representation of the article in the downloaded JSON file
class Article < ApplicationRecord
  belongs_to :s3_download
  has_many :likes

  validates :external_id, presence: true
  validates :title, presence: true
  validates :description, presence: true
end
