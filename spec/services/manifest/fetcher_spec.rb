# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Manifest::Fetcher, type: :service do
  include S3DownloadHelper

  describe '.call' do
    context 'with original manifest' do
      let(:article_list) { file_fixture('original_test_fixtures.json').read }
      before { stub_s3_download(article_list) }

      it 'stores the JSON file', aggregate_failures: true do
        expect { described_class.call }.to change { S3Download.count }.by(1)
        expect(S3Download.last.manifest).to eq JSON.parse(article_list)
      end

      it 'invokes Sync.call with the new S3Download' do
        expect(::Manifest::Sync).to receive(:call)
        described_class.call
      end
    end
  end
end
