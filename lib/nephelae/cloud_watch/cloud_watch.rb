module Nephelae
  class CloudWatch

    attr_accessor :aws_access_key_id, :aws_secret_access_key, :aws_session_token, :aws_credentials_expire_at, :url

    def initialize(options={})
      options[:region] ||= 'us-east-1'
      @host       = options[:host] || "monitoring.#{options[:region]}.amazonaws.com"
      @path       = options[:path]        || '/'
      @port       = options[:port]        || 443
      @scheme     = options[:scheme]      || 'https'
      @aws_access_key_id      = options[:aws_access_key_id]
      @aws_secret_access_key  = options[:aws_secret_access_key]
      @aws_session_token      = options[:aws_session_token]
      @aws_credentials_expire_at = options[:aws_credentials_expire_at]

      @url = "#{@scheme}://#{@host}:#{@port}#{@path}"

    end

    def request(params)
      body = AWS.signed_params(
        params,
        {
          :aws_access_key_id  => @aws_access_key_id,
          :aws_session_token  => @aws_session_token,
          :aws_secret_access_key => @aws_secret_access_key,
          :host               => @host,
          :path               => @path,
          :port               => @port,
          :version            => '2010-08-01'
        }
      )

      AWS.request(@url, {
         :body       => body,
         :expects    => 200,
         :headers    => { 'Content-Type' => 'application/x-www-form-urlencoded' },
         :host       => @host,
         :method     => 'POST'
       })
    end

    def put_metric(metric)
      params = metric.params
      request(metric.params) unless params.nil?
    end

  end
end
