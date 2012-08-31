module Nephelae

  class RedisStatus < Plugin

    def get_metrics
      metrics = Metrics.new(namespace)
      output = `#{command}`

      if $?.success?
        stats = parse_status(output)
        metrics.append_metric('Up', 1)
        metrics.append_metric('MasterLinkStatus', (stats[:master_link_status] == 'up' ? 1 : 0)) unless stats[:master_link_status].nil?
        metrics.append_metric('MasterIOSecondsAgo', stats[:master_last_io_seconds_ago], {unit: 'Seconds'}) unless stats[:master_last_io_seconds_ago].nil?
        metrics.append_metric('ChangesSinceLastSave', stats[:changes_since_last_save], {unit: 'Count'})
        metrics.append_metric('UsedMemory', stats[:used_memory], {unit: 'Bytes'})
        metrics.append_metric('ConnectedSlaves', stats[:connected_slaves], {unit: 'Count'})
        metrics.append_metric('ConnectedClients', stats[:connected_clients], {unit: 'Count'})
      else
        metrics.append_metric('Up', 0)
      end

      return metrics

    end

    private
      def parse_status(body)
        ret = {}
        mls = body.match(/master_link_status:(\w+)/)
        ret[:master_link_status] = mls.nil? ? "down" : mls[1]

        mlio = body.match(/master_last_io_seconds_ago:(\d+)/)
        ret[:master_last_io_seconds_ago] = mlio[1] unless mlio.nil?

        ret.merge({
          :changes_since_last_save => body.match(/changes_since_last_save:(\d+)/)[1],
          :used_memory => body.match(/used_memory:(\d+)/)[1],
          :connected_slaves => body.match(/connected_slaves:(\d+)/)[1],
          :connected_clients => body.match(/connected_clients:(\d+)/)[1]
        })
      end

      def command
        port = config[:port].nil? ? "" : " -p #{config[:port]}"
        password = config[:password].nil? ? "" : " -a #{config[:password]}"
        "/usr/local/bin/redis-cli#{port}#{password} info"
      end

      def default_namespace
        "Nephelae/Redis"
      end

  end

end
