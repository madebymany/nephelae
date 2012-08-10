module Nephelae
  class Metrics
    attr_accessor :params, :namespace, :instance_id

    attr_reader :mcount

    def initialize(namespace, options = {})
      #code to get the instance id from ec2 metadata
      @instance_id = options[:instance_id] || AWS.get_instance_id
      @params = {}
      @params['Action'] = 'PutMetricData'
      @params['Namespace'] = namespace
      @mcount = 0
    end

    def append_metric(name, value, options)
      dim_count = 1
      @mcount = @mcount + 1
      params["MetricData.member.#{@mcount}.MetricName"] = name
      params["MetricData.member.#{@mcount}.Value"] = value
      params["MetricData.member.#{@mcount}.Unit"] = options[:unit] || 'None'
      params["MetricData.member.#{@mcount}.Timestamp"] = options[:timestamp] if options[:timestamp]

      if @instance_id
        params["MetricData.member.#{@mcount}.Dimensions.member.#{dim_count}.Name"] = 'InstanceId'
        params["MetricData.member.#{@mcount}.Dimensions.member.#{dim_count}.Value"] = @instance_id
      end

    end

  end
end
