class Article < ApplicationRecord
  belongs_to :s3_download

  validates :external_id, presence: true
  validates :title, presence: true
  validates :description, presence: true
end
