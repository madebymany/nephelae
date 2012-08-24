module Nephelae

  class NephelaeProcess

    def initialize(params = {})
    end

    def get_metrics
      metrics = Metrics.new('Application/Nephelae')

      #if we are doing this we are up
      metrics.append_metric('Up', 1)

      return metrics

    end

  end

end
