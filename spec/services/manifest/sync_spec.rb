# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Manifest::Sync, type: :service do
  subject { described_class.new(s3_download_record: s3_download) }
  describe '#call' do
    let(:manifest_fixture) { JSON.parse(file_fixture('two_articles.json').read) }
    let!(:s3_download) { FactoryBot.create :s3_download, manifest: manifest_fixture }

    context 'with two article manifest' do
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
      let(:manifest_fixture) { JSON.parse(file_fixture('two_articles.json').read) }
      let!(:first_s3_download) { FactoryBot.create :s3_download, manifest: manifest_fixture }
      before do
        described_class.new(s3_download_record: s3_download).call
      end

      context 'with second identical downloaded manifest' do
        let!(:s3_download) { FactoryBot.create :s3_download, manifest: manifest_fixture }

        it 'creates no duplicate articles' do
          expect { subject.call }.not_to change { Article.count }
        end

        it 'updates all article#s3_download_id to latest S3Download record' do
          expect { subject.call }.to change { Article.pluck(:id) }.to [s3_download.id, s3_download.id]
        end
      end

      context 'when second downloaded manifest contains product updates' do
        let(:second_manifest_diff) do
          [
            {
              "id": 4274368,
              "title": "Tulip Bulbs",
              "description": "Net of 30+ tulip bulbs mixed colours"
            },
            {
              "id": 4158741,
              "title": "Halloween decorations ",
              "description": "Halloween decorations octonauts theme",
            }
          ]
        end

        let!(:s3_download) { FactoryBot.create :s3_download, manifest: manifest_fixture.merge(second_manifest_diff) }

        it 'creates no duplicate articles' do
          expect { subject.call }.not_to change { Article.count }
        end

        it 'updates all article#s3_download_id to latest S3Download record' do
          expect { subject.call }.to change { Article.pluck(:id) }.to [s3_download.id, s3_download.id]
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
        let(:manifest_fixture) { JSON.parse(file_fixture('five_different_articles.json').read) }
        let!(:s3_download) { FactoryBot.create :s3_download, manifest: manifest_fixture }

        it 'creates new articles' do
          expect { subject.call }.to change { Article.count }.by(5)
        end

        it 'associates them to the S3Download' do
          expect { subject.call }.to change { s3_download.reload.articles.count }.by(5)
        end

        it 'leaves the old articles alone' do
          expect { subject.call }.not_to change { first_s3_download.reload.articles.count }
        end
      end
    end
  end
end
