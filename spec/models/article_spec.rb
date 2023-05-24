# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Article, type: :model do
  describe '#associations' do
    it { should belong_to :s3_download }
    it { should have_many :likes }
  end

  describe '#validations' do
    it { should validate_presence_of(:external_id) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end
end
