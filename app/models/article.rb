class Article < ApplicationRecord
  attribute :external_id, :integer
  attribute :title, :string
  attribute :description, :string
end
