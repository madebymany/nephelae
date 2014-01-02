require 'aws-sdk'

module Nephelae
  class CloudWatch
    include Logging

    attr_accessor :aws_access_key_id, :aws_secret_access_key, :aws_session_token, :aws_credentials_expire_at, :url

    def initialize(options={})
      opts = {
        access_key_id: options[:aws_access_key_id],
        secret_access_key: options[:aws_secret_access_key],
        region: options[:region]
      }

      AWS.config opts
      @cw = AWS::CloudWatch.new
    end

    def put_metric(instance_name, metric)
      params = metric.params
      data = {}
      data[:namespace] = metric.namespace
      data[:metric_data] = []
      unless params.nil?
        params.each do |param|
          Logging.logger.warn "Key : #{param[:name]}, Value : #{param[:value]}"
          options = {}
          options[:metric_name] = param[:name]
          options[:dimensions] = [
            {name: 'InstanceId', value: instance_name}
          ]
          options[:timestamp] = Time.now.iso8601
          options[:value] = param[:value]
          options[:unit] = param[:unit]
          data[:metric_data] << options
        end
        @cw.put_metric_data(data)
      end
    end

  end
end
