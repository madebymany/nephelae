require 'eventmachine'
require 'rufus/scheduler'
module Nephelae
  class Runner

    attr_accessor :aws_access_key_id, :aws_secret_access_key

    def initialize(config = {})
      @aws_access_key_id = config[:aws_access_key_id]
      @aws_secret_access_key = config[:aws_secret_access_key]
    end
    
    def run

      EM.run {
          cloud = CloudWatch.new({aws_access_key_id: @aws_access_key_id, aws_secret_access_key: @aws_secret_access_key})

          #make one request to put a cloud watch metric for nephelae being up. hopefully this can make it bork early if anything is wrong
          cloud.put_metric(NephelaeProcess.new.get_metrics)

          plugins = [DiskSpace.new, MemUsage.new, NephelaeProcess.new, PassengerStatus.new]
          scheduler = Rufus::Scheduler::EmScheduler.start_new

          scheduler.every '5m' do
            plugins.each {|p| cloud.put_metric(p.get_metrics) }
          end
      }
    end

  end
end
