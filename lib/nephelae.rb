require_relative "nephelae/version"
require_relative "nephelae/logging"
require_relative "nephelae/cloud_watch/cloud_watch"
require_relative "nephelae/cloud_watch/metrics"

require_relative "nephelae/plugins/plugin"
require_relative "nephelae/plugins/disk_space"
require_relative "nephelae/plugins/mem_usage"
require_relative "nephelae/plugins/nephelae_process"
require_relative "nephelae/plugins/passenger_status"
require_relative "nephelae/plugins/redis"

require_relative "nephelae/runner"

module Nephelae
  # Your code goes here...
end
