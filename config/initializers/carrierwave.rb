if Rails.env.test?# || Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end

  # make sure our uploader is auto-loaded
  FileForTaskUploader

  # use different dirs when testing
  CarrierWave::Uploader::Base.descendants.each do |klass|
    next if klass.anonymous?
    klass.class_eval do
      def cache_dir
        "#{Rails.root}/spec/support/uploads/tmp"
      end

      def store_dir
        # "#{Rails.root}/spec/support/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      end
    end
  end
else
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
end