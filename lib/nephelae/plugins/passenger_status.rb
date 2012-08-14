module Nephelae

  class PassengerStatus

    def initialize(params = {})
    end

    def command
      "passenger-status 2>&1"
    end

    def get_metrics
      metrics = Metrics.new('Linux/Passenger')
      output = `#{command}`

      if $?.success?
        stats = parse_status(output)
        metrics.append_metric('MaxInstances', stats[:max])
        metrics.append_metric('CountInstances', stats[:count])
        metrics.append_metric('ActiveInstances', stats[:active])
        metrics.append_metric('InactiveInstances', stats[:inactive])
        metrics.append_metric('WaitingOnGlobalQueue', stats[:waiting_on_global_queue])

      end

      return metrics

    end

    private
      def parse_status(body)
        { :max => body.match(/max\s+=\s+(\d+)/)[1],
          :count => body.match(/count\s+=\s+(\d+)/)[1],
          :active => body.match(/active\s+=\s+(\d+)/)[1],
          :inactive => body.match(/inactive\s+=\s+(\d+)/)[1],
          :waiting_on_global_queue => body.match(/waiting on global queue\:\s+(\d+)/i)[1]
        }
      end

  end

end
