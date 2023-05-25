# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Manifest::Sync, type: :service do
  subject { described_class.new(s3_download_record: s3_download) }
  describe '#call' do
    context 'with two article manifest' do
      let(:two_articles) { JSON.parse(file_fixture('two_articles.json').read) }
      let!(:s3_download) { FactoryBot.create :s3_download, manifest: two_articles }

      it 'creates and associates new articles', aggregate_failures: true do
        expect { subject.call }.to change { s3_download.reload.articles.count }.by(2)
      end

      it 'assigns :external_id, :title, :description to created articles' do
        subject.call
        last_article = Article.last
        expect(last_article.title).to eq 'Christmas decorations '
        expect(last_article.description).to eq 'Christmas decorations octonauts theme'
        expect(last_article.external_id).to eq 4_158_741
      end
    end

    describe 'multiple updates' do
      let(:two_articles) { JSON.parse(file_fixture('two_articles.json').read) }
      let!(:first_s3_download) { FactoryBot.create :s3_download, :with_articles, manifest: two_articles }

      context 'with second identical downloaded manifest' do
        let!(:s3_download) { FactoryBot.create :s3_download, manifest: two_articles }

        it 'creates no duplicate articles' do
          expect { subject.call }.not_to(change { Article.count })
        end

        it 'updates all article#s3_download_id to latest S3Download record' do
          expect { subject.call }.to change { Article.pluck(:s3_download_id) }.to [s3_download.id, s3_download.id]
        end
      end

      context 'when second downloaded manifest contains product updates' do
        let(:two_articles_with_updates) { JSON.parse(file_fixture('two_articles_with_updates.json').read) }
        let!(:s3_download) { FactoryBot.create :s3_download, manifest: two_articles_with_updates }

        it 'creates no duplicate articles' do
          expect { subject.call }.not_to(change { Article.count })
        end

        it 'updates all article#s3_download_id to latest S3Download record' do
          expect { subject.call }.to change { Article.pluck(:s3_download_id) }.to [s3_download.id, s3_download.id]
        end

        it 'updates the articles' do
          subject.call
          last_article = Article.last
          first_article = Article.first
          expect(first_article.title).to eq "Tulip Bulbs"
          expect(first_article.description).to eq "Net of 30+ tulip bulbs mixed colours"
          expect(last_article.title).to eq "Halloween decorations "
          expect(last_article.description).to eq "Halloween decorations octonauts theme"
        end
      end

      context 'with second downloaded manifest contains new products' do
        let(:five_different_articles) { JSON.parse(file_fixture('five_different_articles.json').read) }
        let!(:s3_download) { FactoryBot.create :s3_download, manifest: five_different_articles }

        it 'creates new articles' do
          expect { subject.call }.to change { Article.count }.by(5)
        end

        it 'associates them to the S3Download' do
          expect { subject.call }.to change { s3_download.reload.articles.count }.by(5)
        end

        it 'leaves the old articles alone' do
          expect { subject.call }.not_to(change { first_s3_download.reload.articles.count })
        end
      end
    end
  end
end
