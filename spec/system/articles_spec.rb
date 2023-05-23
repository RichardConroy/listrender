# frozen_string_literal: true

require 'rails_helper'

module ArticleFinders
  def first_article
    first('div.article')
  end

  def like_count
    find('.like_count')
  end
end

RSpec.describe "Articles", type: :system do
  include ArticleFinders

  before do
    driven_by(:rack_test)
  end

  def stub_s3_download(response = file_fixture('original_test_fixtures.json') )
    stub_request(:get, 'https://s3-eu-west-1.amazonaws.com/olio-staging-images/developer/test-articles-v4.json')
      .to_return(body: response, headers: { content_type: 'application/json' })
  end

  describe 'article list' do
    context 'with original response' do
      before do
        stub_s3_download
      end

      it 'shows results from the fixture archive' do
        visit articles_path

        expect(page).to have_content 'Ambipur air freshener plugin'
        expect(page).to have_content 'Device only but refills are available most places'
      end
    end
  end

  describe 'article likes' do
    before { stub_s3_download file_fixture('two_articles.json') }

    it 'shows a like button with each article' do
      visit articles_path
      binding.pry
      expect(first_article).to have_button 'Like'
      expect(first_article.like_count).to have_text '0'
    end

  end
end
