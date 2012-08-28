module Nephelae

  class NephelaeProcess < Plugin

    def get_metrics
      metrics = Metrics.new(namespace)

      #if we are doing this we are up
      metrics.append_metric('Up', 1)

      return metrics

    end

    private

      def default_namespace
        'Nephelae/Process'
      end

  end

end
