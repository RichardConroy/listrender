# frozen_string_literal: true

# A representation of a user possession that is being offered up for collection
class Article < ApplicationRecord
  attribute :external_id, :integer
  attribute :title, :string
  attribute :description, :string
end
