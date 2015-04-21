class Admin::UploadsController < Admin::BaseController
  respond_to :json

  def show
    @expires = Time.now.utc + 10.hour
    filename = upload_params[:name].parameterize
    today = Date.today
    
    @filetype = upload_params[:type]

    image_or_video = case @filetype
                     when %r{\Avideo/.*\z} then 'video'
                     when %r{\Aimage/.*\z} then 'image'
                     else raise ArgumentError.new('Only images and videos are allowed.')
                     end
    
    @key = "#{Rails.env}/#{image_or_video}/source/#{ today.year }/#{ today.month }/#{ today.day }/#{ filename }"
    
    render json: {
      acl: 'public-read',
      awsaccesskeyid: ENV['AWS_ACCESS_KEY_ID'],
      bucket: ENV['S3_BUCKET_NAME'],
      expires: @expires,
      key: @key,
      policy: s3_policy(image_or_video),
      signature: s3_bucket_signature,
      success_action_status: '201',
      'Content-Type' => @filetype,
      'Cache-Control' => 'max-age=630720000, public'
    }, status: :ok
  end

  private

  def s3_bucket_signature
    Base64.strict_encode64(
      OpenSSL::HMAC.digest(
        OpenSSL::Digest.new('sha1'),
        ENV['AWS_SECRET_ACCESS_KEY'],
        @s3_policy
      )
    )
  end


  def s3_policy(type)
    @s3_policy ||= Base64.strict_encode64(
      {
        expiration: @expires,
        conditions: [
          { bucket: ENV['S3_BUCKET_NAME'] },
          { acl: 'public-read' },
          { expires: @expires },
          { success_action_status: '201' },
          [ 'starts-with', '$key', "#{Rails.env}/" ],
          [ 'starts-with', '$Content-Type', "#{type}/" ],
          [ 'starts-with', '$Cache-Control', '' ],
          [ 'content-length-range', 0, 524288000 ]
        ]
      }.to_json
    )
  end

  def upload_params
    params.permit(:type,:name)
  end
  
  
end
