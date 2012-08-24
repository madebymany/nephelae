module Nephelae

  class DiskSpace < Plugin

    def get_metrics
      metrics = Metrics.new(namespace)
      output = `#{command}`
      stats = output.split(/\n/).last.split(/\s+/)

      percent = stats[4].chomp('%')
      metrics.append_metric('DiskSpaceUtilization', percent, {unit: 'Percent'})
      metrics.append_metric('DiskSpaceUsed', stats[2], {unit: 'Kilobytes'})
      metrics.append_metric('DiskSpaceAvailable', stats[1], {unit: 'Kilobytes'})

      return metrics

    end

    private

      def default_namespace
        'Nephelae/Linux'
      end

      def command
        path = config[:path] || '/'
        "/bin/df -k -l -P #{path}"
      end

  end

end
