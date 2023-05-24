# frozen_string_literal: true

require 'rails_helper'

# Crude method to verify if all your factories are generating valid objects. Your tests are
# questionable if they are built with invalid factories.
# Better approach is to use FactoryBot.lint
# https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#linting-factories

FactoryBot.factories.map(&:name).each do |factory_name|
  RSpec.describe "The #{factory_name} factory" do
    it 'is valid' do
      expect(FactoryBot.build(factory_name)).to be_valid
    end
  end
end
