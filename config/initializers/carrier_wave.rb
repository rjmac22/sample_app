if Rails.env.production?
    CarrierWave.configure do |config|
        configure.fog_credentials = {
            # Configuration for Amazon S3
            :provider              => 'AWS'
            :aws_access_key_id     => ENV['AKIAJADO52QCT3JTV4FQ']
            :aws_secret_access_key => ENV['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']
        }
        config.fog_directory = ENV['S3_BUCKET']
    end
end
