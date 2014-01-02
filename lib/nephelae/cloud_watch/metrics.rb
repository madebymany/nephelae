require_relative '../logging'

module Nephelae
  class Metrics
    attr_accessor :params, :namespace, :instance_id

    attr_reader :mcount

    def initialize(namespace, options = {})
      #code to get the instance id from ec2 metadata
      @instance_id = options[:instance_id]
      @params = []
      @namespace = namespace
      @mcount = 0
    end

    def append_metric(name, value, options = {})
      dim_count = 1
      @mcount = @mcount + 1
      param = {}
      param[:name] = name
      param[:value] = value
      param[:unit] = options[:unit] || 'None'
      param[:timestamp] = options[:timestamp] if options[:timestamp]

      @params << param
    end

    def params
      @mcount == 0 ? nil : @params
    end

  end
end
