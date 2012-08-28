require 'eventmachine'
require 'rufus/scheduler'
module Nephelae
  class Runner
    include Logging

    attr_accessor :aws_access_key_id, :aws_secret_access_key, :region, :plugins

    def initialize(config = {})
      @aws_access_key_id = config[:aws_access_key_id]
      @aws_secret_access_key = config[:aws_secret_access_key]
      @region = config[:region] || 'us-east-1'
      @plugins = config[:plugins] || default_plugins
    end
    
    def run
      log.warn "starting nephelae"
      EM.run {
          cloud = CloudWatch.new({aws_access_key_id: @aws_access_key_id, aws_secret_access_key: @aws_secret_access_key, region: @region})

          #make one request to put a cloud watch metric for nephelae being up. hopefully this can make it bork early if anything is wrong
          cloud.put_metric(NephelaeProcess.new.get_metrics)

          scheduler = Rufus::Scheduler::EmScheduler.start_new

          plugins.each do |name, config|
            schedule = config.delete(:schedule) || '5m'
            klass_name = config.delete(:plugin_class)
            klass = Object.const_get('Nephelae').const_get(klass_name)
            p = klass.new(config)
            scheduler.every schedule do
              begin
                cloud.put_metric(p.get_metrics)
              rescue StandardError => e
                log.error("nephelae plugin #{p.class} failed #{e.message}")
                log.error(e.backtrace.join("\n"))
              end
            end
          end

      }
    end

    private
      def default_plugins
        plugins = {}
        plugins[:disk_space] = {plugin_class: "DiskSpace", schedule: "5m", path: '/'}
        plugins[:mem_usage] = {plugin_class: "MemUsage", schedule: "5m"}
        plugins
      end

  end
end
