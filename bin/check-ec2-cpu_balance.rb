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
def sensu_client_socket(msg)
    u = UDPSocket.new
    u.send(msg + "\n", 0, '127.0.0.1', 3030)
  end

#   def handlers
#     config[:handlers].split(',').map { |x| x.strip }
#   end

  def send_ok(check_name, msg, metric)
    d = { 'name' => check_name, 'status' => 0, 'output' => 'OK: ' + msg }#, 'handlers' => handlers }
    d['type'] = 'metric' if metric
    sensu_client_socket d.to_json
  end

  def send_warning(check_name, msg, metric)
    d = { 'name' => check_name, 'status' => 1, 'output' => 'WARNING: ' +  msg }#, 'handlers' => handlers }
    d['type'] = 'metric' if metric
    sensu_client_socket d.to_json
  end

  def send_critical(check_name, msg, metric)
    d = { 'name' => check_name, 'status' => 2, 'output' => 'CRITICAL: ' +  msg }#,  'handlers' => handlers }
    d['type'] = 'metric' if metric
    sensu_client_socket d.to_json
  end
  ####
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
        private_addr = instance.private_ip_address
        result = data id
        tag = config[:tag] ? " #{instance_tag(instance, config[:tag])}" : ''
        output = "#{tag}_#{vpc_fullname}-#{private_addr}"
        test_name = output
        unless result.nil?
          if result < config[:critical]
            send_critical(
            test_name,
            output,
            config[:metric]
          )        
            level = 2
             
          elsif config[:warning] && result < config[:warning]
            send_warning(
            test_name,
            output,
            config[:metric]
          ) 
          
                  level = 1 if level.zero?
            
          end
        end
      end
    end
    ok if level.zero?
    warning if level == 1
    critical if level == 2
  end
end
