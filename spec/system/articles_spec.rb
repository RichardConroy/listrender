# frozen_string_literal: true

require 'rails_helper'

# Capybara helper methods
module ArticleFinders
  def first_article
    first('div.article')
  end

  def first_article_like_count
    first_article.find('.like_count')
  end

  def like_count
    find('.like_count')
  end
end

RSpec.describe "Articles", type: :system do
  include ArticleFinders
  include S3DownloadHelper

  before do
    driven_by(:rack_test)
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

      expect(first_article).to have_button 'Like'
      expect(first_article_like_count).to have_text '0'
    end
  end

  describe 'liking an article' do
    before { stub_s3_download file_fixture('two_articles.json') }

    it 'increments the like count' do
      visit articles_path

      expect(first_article_like_count.text).to eq('0 likes')
      within first_article do
        click_button 'Like'
      end
      expect(first_article_like_count.text).to eq('1 likes')

      within first_article do
        click_button 'Like'
      end
      expect(first_article_like_count.text).to eq('2 likes')
    end
  end
end
