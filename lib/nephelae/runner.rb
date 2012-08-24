require 'eventmachine'
require 'rufus/scheduler'
module Nephelae
  class Runner
    include Logging

    attr_accessor :aws_access_key_id, :aws_secret_access_key, :region

    def initialize(config = {})
      @aws_access_key_id = config[:aws_access_key_id]
      @aws_secret_access_key = config[:aws_secret_access_key]
      @region = config[:region]
    end
    
    def run
      log.warn "starting nephelae"
      EM.run {
          cloud = CloudWatch.new({aws_access_key_id: @aws_access_key_id, aws_secret_access_key: @aws_secret_access_key, region: @region})

          #make one request to put a cloud watch metric for nephelae being up. hopefully this can make it bork early if anything is wrong
          cloud.put_metric(NephelaeProcess.new.get_metrics)

          plugins = [DiskSpace.new, MemUsage.new, NephelaeProcess.new, PassengerStatus.new, RedisStatus.new]
          scheduler = Rufus::Scheduler::EmScheduler.start_new

          scheduler.every '5m' do
            plugins.each do |p| 
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

  end
end
