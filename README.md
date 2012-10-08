# Nephelae

The Nephelae were the nymph of clouds (http://www.theoi.com/Nymphe/Nephelai.html) carrying water from Earth to Heaven. In this particular case the nephelae carry data from servers to Amazon EC2 Cloud Watch. It was written to send disk space and memory usage of EC2 servers but can be extended to query any metrics and upload them on a regular basis.

For example the Redis plugin will collect the UsedMemory, ConnectedSlaves, ConnectedClients, ChangesSinceLastSave, MasterIOSecondsAgo, MasterLinkStatus and Up of a Redis instance and send this to AWS CloudWatch. We use this to put CloudWatch Alarms on the Up and MasterLinkStatus metrics to notify if Redis goes down or loses connection with the Master

The Nephelae gem contains a daemon process which has a number of plugins to collect stats. The daemon process is configured through a yaml file 

## Installation

To install as a gem

    $ gem install nephelae

You probably will want to install nephelae as part of a server setup. An example Chef cookbook can be found at https://github.com/madebymany/cookbooks/tree/master/nephelae

## Usage

To run the nephelae deamon

    $ nephelae start

This will start with default settings looking for a config yaml file in .etc/nephelae.yml. It will use /var/log as a log directory and /var/run for a pid directory

To start with full config settings
    $ nephelae start --config /home/nephelae/config.yml --logdir /home/nephelae/nephelae.log --piddir /home/nephelae/nephelae.pid --loglevel debug

## Configuration

The config yaml file is used to define the AWS access keys and plugin settings

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
