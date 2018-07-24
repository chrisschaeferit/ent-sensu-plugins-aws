#! /usr/bin/env ruby
#
# check-ec2-cpu_balance
#
# DESCRIPTION:
#   This plugin retrieves the value of the cpu balance for all servers
#
# OUTPUT:
#   plain-text
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: aws-sdk
#   gem: sensu-plugin
#
# USAGE:
#   ./check-ec2-cpu_balance -c 20
#   ./check-ec2-cpu_balance -w 25 -c 20
#   ./check-ec2-cpu_balance -c 20 -t 'Name'
#
# NOTES:
#
# LICENSE:
#   Shane Starcher
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugins-aws'
require 'sensu-plugin/check/cli'
require 'aws-sdk'
require 'socket'


class EC2CpuBalance < Sensu::Plugin::Check::CLI
  include Common

  option :critical,
         description: 'Trigger a critical when value is below VALUE',
         short: '-c VALUE',
         long: '--critical VALUE',
         proc: proc(&:to_f),
         required: true

  option :warning,
         description: 'Trigger a warning when value is below VALUE',
         short: '-w VALUE',
         long: '--warning VALUE',
         proc: proc(&:to_f)

  option :aws_region,
         short: '-r R',
         long: '--region REGION',
         description: 'AWS region',
         default: 'us-east-1'

  option :tag,
         description: 'Add instance TAG value to warn/critical message.',
         short: '-t TAG',
         long: '--tag TAG'

  def data(instance)
    client = Aws::CloudWatch::Client.new
    stats = 'Minimum'
    period = 60
    resp = client.get_metric_statistics(
      namespace: 'AWS/EC2',
      metric_name: 'CPUCreditBalance',
      dimensions: [
        {
          name: 'InstanceId',
          value: instance
        }
      ],
      start_time: Time.now - period * 10,
      end_time: Time.now,
      period: period,
      statistics: [stats]
    )

    return resp.datapoints.first.send(stats.downcase) unless resp.datapoints.first.nil?
  end


  def instance_tag(instance, tag_name)
    tag = instance.tags.select { |t| t.key == tag_name }.first
    tag.nil? ? '' : tag.value
  end
  ####
def sensu_client_socket
    u = UDPSocket.new
    u.send(msg + "\n", 0, '127.0.0.1', 3030)
  end

  def run
    ec2 = Aws::EC2::Client.new
    instances = ec2.describe_instances(
      filters: [
        {
          name: 'instance-state-name',
          values: ['running']
        }
      ]
    )
    vpcnames = ec2.describe_vpcs(
            filters: [
                    {
                name: 'tag-key',
                values: ['Name']
                    }
            ]
    )
    vpc_fullname = vpcnames.data[:vpcs].first.tags.find{|tag| tag.key == 'Name' }.value
    level = 0
    
    udp = UDPSocket.new
    
    instances.reservations.each do |reservation|
      reservation.instances.each do |instance|
        next unless instance.instance_type.start_with? 't2.'
        id = instance.instance_id
        private_addr = instance.private_ip_address
        result = data id
        messages = "\n"
        tag = config[:tag] ? " #{instance_tag(instance, config[:tag])}" : ''
        output = "#{tag}-#{vpc_fullname}-#{private_addr}"
        unless result.nil?
          if result < config[:critical]
            messages << "#{output} is below critical threshold [#{result} < #{config[:critical]}]\n"
            udp.send(messages, 0, '127.0.0.1', 3030)
            level = 2
             
          elsif config[:warning] && result < config[:warning]
            messages << "#{output} is below warning threshold [#{result} < #{config[:warning]}]\n"
            udp.send(messages, 0, '127.0.0.1', 3030)

            level = 1 if level.zero?
            
          end
        end
      end
    end
    ok(output) if level.zero?
    warning(output) if level == 1
    critical(output) if level == 2
  end
end
