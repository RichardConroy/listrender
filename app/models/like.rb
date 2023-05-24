# frozen_string_literal: true

# Record to capture absolute like counts against an article
class Like < ApplicationRecord
  belongs_to :article
end
