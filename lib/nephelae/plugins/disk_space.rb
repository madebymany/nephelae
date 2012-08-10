module Nephelae

  class DiskSpace
    attr_accessor :path

    def initialize(params = {})
      @path = params[:path] || '/'
    end

    def command
      "/bin/df -k -l -P #{@path}"
    end

    def get_metrics
      metrics = Metrics.new('System/Linux')
      output = `#{command}`
      stats = output.split(/\n/).last.split(/\s+/)

      percent = stats[4].chomp('%')
      metrics.append_metric('DiskSpaceUtilization', percent, {unit: 'Percent'})
      metrics.append_metric('DiskSpaceUsed', stats[2], {unit: 'Kilobytes'})
      metrics.append_metric('DiskSpaceAvailable', stats[1], {unit: 'Kilobytes'})

      return metrics

    end

  end

end
