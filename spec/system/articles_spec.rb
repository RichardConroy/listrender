# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Articles", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'article list' do
    context 'with original response' do
      let(:json_fixture) { file_fixture 'original_test_fixtures.json' }
      before do
        stub_request(:get, 'https://s3-eu-west-1.amazonaws.com/olio-staging-images/developer/test-articles-v4.json')
          .to_return(body: json_fixture, headers: { content_type: 'application/json' })
      end

      it 'shows results from the fixture archive' do
        visit articles_path

        expect(page).to have_content 'Ambipur air freshener plugin'
        expect(page).to have_content 'Device only but refills are available most places'
      end
    end
  end
end
