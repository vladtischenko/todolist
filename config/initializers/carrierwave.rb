CarrierWave.configure do |config|
  config.storage    = :aws
  config.aws_bucket = 'todolist-vlad'
  config.aws_acl    = :public_read
  # config.asset_host = 'https://s3-us-west-2.amazonaws.com'
  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 365

  config.aws_credentials = {
    access_key_id: ENV['S3_KEY'],
    secret_access_key: ENV['S3_SECRET']
  }
end