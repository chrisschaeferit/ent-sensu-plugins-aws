
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
require 'json'

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


  def send_client_socket(data)
    udp = UDPSocket.new
    udp.send(data + "\n", 0, '127.0.0.1', 3030)
  end

def send_ok(source_name, check_name, msg)
    event = {
      'name' => check_name,
      'source' => source_name,
      'status' => 0,
      'output' => "#{self.class.name} OK: #{msg}",
      'handlers' => config[:handlers]
    }
    send_client_socket(event.to_json)
  end

def send_warning(source_name, check_name, msg)

    event = {
      'name' => check_name,
      'source' => source_name,
      'status' => 1,
      'output' => "#{self.class.name} WARNING: #{msg}",
      'handlers' => config[:handlers]
    }
    send_client_socket(event.to_json)
  end

  def send_critical(source_name, check_name, msg)
    event = {
     'name' => check_name,
      'source' => source_name,
      'status' => 2,
      'output' => "#{self.class.name} CRITICAL: #{msg}",
      'handlers' => config[:handlers]
    }
    send_client_socket(event.to_json)
  end

  def send_unknown(source_name, check_name, msg)
    event = {
      'name' => check_name,
      'source' => source_name,
      'status' => 3,
      'output' => "#{self.class.name} UNKNOWN: #{msg}",
      'handlers' => config[:handlers]
    }
    send_client_socket(event.to_json)
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

    instances.reservations.each do |reservation|
      reservation.instances.each do |instance|
        next unless instance.instance_type.start_with? 't2.'
        id = instance.instance_id
        availzone = instance.placement.availability_zone
        private_addr = instance.private_ip_address
        result = data id
        messages = "\n"
        tag = instance.tags.find{|tag| tag.key == 'Name'}.value
        source_name = "#{tag}-#{vpc_fullname}-#{private_addr}"
        check_name = "#{tag}_#{availzone}"
        level = 3 if result.nil?
        unless result.nil?
          if result < config[:critical]
          msg = "#{tag}-#{vpc_fullname}-#{private_addr} is below critical threshold [#{result} < #{config[:critical]}]\n"
           send_critical(source_name, check_name, msg)
           #level = 2

          elsif config[:warning] && result < config[:warning]
           msg = "#{tag}-#{vpc_fullname}-#{private_addr} is below warning threshold [#{result} < #{config[:warning]}]\n"
           send_warning(source_name, check_name, msg)
           #level = 1 if level.zero?

   # if instances

    if level == 0
     msg = "All checks running"
    end

    if instances.reservations.nil?
      level = 1
      msg = "No instances checked in as running in #{config[:aws_region]}."
    end
    
    if level == 2
    output = "test"
    end

    if level == 3
    output = "ERROR, something is wrong with the API call."
    end


    ok(msg) if level.zero?
    warning(msg) if level == 1
    critical(msg) if level == 2
    unknown(msg) if level == 3

          end
        end
      end
    end

  end
end

