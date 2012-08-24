module Nephelae

  class MemUsage

    def initialize(params = {})
    end

    def command
      "cat /proc/meminfo"
    end

    def get_metrics
      metrics = Metrics.new('System/Linux')
      output = `#{command}`

      if $?.success?
        stats = parse_status(output)

        mem_total = stats[:mem_total]
        metrics.append_metric('MemoryTotal', mem_total, {unit: 'Kilobytes'})

        mem_free = stats[:mem_free] + stats[:buffers] + stats[:cached]
        metrics.append_metric('MemoryFree', mem_free, {unit: 'Kilobytes'})

        mem_used = stats[:mem_total] - mem_free
        metrics.append_metric('MemoryUsed', mem_used, {unit: 'Kilobytes'})

        unless mem_total == 0
          mem_used_percent = (mem_used.to_f / mem_total.to_f * 100).to_i
          metrics.append_metric('MemoryUsedPercentage', mem_used_percent, {unit: 'Percent'})
        end

        metrics.append_metric('SwapTotal', stats[:swap_total], {unit: 'Kilobytes'})
        metrics.append_metric('SwapFree', stats[:swap_free], {unit: 'Kilobytes'})
        swap_used = stats[:swap_total] - stats[:swap_free]

        metrics.append_metric('SwapUsed', stats[:swap_used], {unit: 'Kilobytes'})

        unless stats[:swap_total] == 0
          swap_used_percent = (stats[:swap_used].to_f / stats[:swap_total].to_f * 100).to_i
          metrics.append_metric('SwapUsedPercentage', swap_used_percent, {unit: 'Percent'})
        end
      end

      return metrics

    end


    private
      def parse_status(body)
        { :mem_total => body.match(/MemTotal:\s+(\d+)\s/)[1].to_i,
          :mem_free => body.match(/MemFree:\s+(\d+)\s/)[1].to_i,
          :buffers => body.match(/Buffers:\s+(\d+)\s/)[1].to_i,
          :cached => body.match(/Cached:\s+(\d+)\s/)[1].to_i,
          :swap_total => body.match(/SwapTotal:\s+(\d+)\s/)[1].to_i,
          :swap_free => body.match(/SwapFree:\s+(\d+)\s/)[1].to_i
        }
      end

  end

end
