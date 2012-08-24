module Nephelae

  class PassengerStatus

    def initialize(params = {})
    end

    def command
      "passenger-status"
    end

    def get_metrics
      metrics = Metrics.new('Application/Passenger')
      output = `#{command}`

      if $?.success?
        stats = parse_status(output)
        metrics.append_metric('MaxInstances', stats[:max], {unit: 'Count'})
        metrics.append_metric('CountInstances', stats[:count], {unit: 'Count'})
        metrics.append_metric('ActiveInstances', stats[:active], {unit: 'Count'})
        metrics.append_metric('InactiveInstances', stats[:inactive], {unit: 'Count'})
        metrics.append_metric('WaitingOnGlobalQueue', stats[:waiting_on_global_queue], {unit: 'Count'})

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
