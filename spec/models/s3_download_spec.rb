# frozen_string_literal: true

require 'rails_helper'

RSpec.describe S3Download, type: :model do
  describe 'validations' do
    it { should validate_presence_of :manifest }
  end
end
