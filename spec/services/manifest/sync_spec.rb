# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Manifest::Sync, type: :service do
  describe '#call' do
    context 'with original manifest' do
      subject { described_class.new(s3_download_record: s3_download) }
      let(:manifest_fixture) { JSON.parse(file_fixture('two_articles.json').read) }
      let!(:s3_download) { FactoryBot.create :s3_download, manifest: manifest_fixture }

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
  end
end
