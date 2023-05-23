module S3DownloadHelper
  def stub_s3_download(response = file_fixture('original_test_fixtures.json'), status = 200)
    stub_request(:get, 'https://s3-eu-west-1.amazonaws.com/olio-staging-images/developer/test-articles-v4.json')
      .to_return(body: response, headers: { content_type: 'application/json' }, status: status)
  end
end
