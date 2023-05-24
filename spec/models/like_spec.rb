# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Like, type: :model do
  describe '#associations' do
    it { should belong_to :article }
  end
end
