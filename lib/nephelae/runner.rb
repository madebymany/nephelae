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
          cloud = CloudWatch.new({aws_access_key_id: @aws_access_key_id, aws_secret_access_key:, @aws_secret_access_key})
          ds = DiskSpace.new
          scheduler = Rufus::Scheduler::EmScheduler.start_new

          scheduler.every '5m' do
            cloud.put_metric(ds.get_metrics)
          end
      }
    end

  end
end
