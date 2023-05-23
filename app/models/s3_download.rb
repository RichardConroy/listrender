class S3Download < ApplicationRecord
  validates :manifest, presence: true
end
