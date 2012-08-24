module Nephelae

  class Plugin
    attr_accessor :config

    def initialize(config = {})
      @config = config
    end

    def get_metrics
      metrics = Metrics.new(namespace)
      return metrics
    end

    def namespace
      namespace = config[:namespace] || default_namespace
    end

    private
      def default_namespace
        "Nephelae/Plugin"
      end

  end

end
