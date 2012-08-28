require 'base64'
require 'excon'
require 'openssl'

module Nephelae
  module AWS

    def self.escape(string)
      string.gsub(/([^a-zA-Z0-9_.\-~]+)/) {
        "%" + $1.unpack("H2" * $1.bytesize).join("%").upcase
      }
    end

    def self.hmac_sign(string_to_sign, key)
      digest = OpenSSL::Digest::Digest.new('sha256')
      OpenSSL::HMAC.digest(digest, key, string_to_sign)
    end

    def self.signed_params(params, options = {})
      params.merge!({
        'AWSAccessKeyId'    => options[:aws_access_key_id],
        'SignatureMethod'   => 'HmacSHA256',
        'SignatureVersion'  => '2',
        'Timestamp'         => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ"),
        'Version'           => options[:version]
      })

      params.merge!({
        'SecurityToken'     => options[:aws_session_token]
      }) if options[:aws_session_token]

      body = ''
      for key in params.keys.sort
        unless (value = params[key]).nil?
          body << "#{key}=#{escape(value.to_s)}&"
        end
      end
      string_to_sign = "POST\n#{options[:host]}:#{options[:port]}\n#{options[:path]}\n" << body.chop
      signed_string = hmac_sign(string_to_sign, options[:aws_secret_access_key])
      body << "Signature=#{escape(Base64.encode64(signed_string).chomp!)}"

      body
    end

    def self.request(url, params, &block)
      excon = Excon.new(url, params)
      excon.request(params, &block)
    end

    def self.get_instance_id
      Excon.get('http://169.254.169.254/latest/meta-data/instance-id').body
      #"i-f746ec92"
    end

  end
end
