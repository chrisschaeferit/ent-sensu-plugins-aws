
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
#   ./check-ec2-cpu_balance -c 20 -r us-east-2
#
# NOTES:
#
# Modified by Chris Schaefer
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
  ##CRITICAL option is %PERCENT based
  option :critical,
         description: 'Trigger a critical when value is below VALUE%',
         short: '-c VALUE',
         long: '--critical VALUE',
         proc: proc(&:to_f),
         required: true


  ##WARNING option is %PERCENT based
  option :warning,
         description: 'Trigger a warning when value is below VALUE%',
         short: '-w VALUE',
         long: '--warning VALUE',
         proc: proc(&:to_f)

  option :aws_region,
         short: '-r R',
         long: '--region REGION',
         description: 'AWS region',
         default: 'us-east-1'

  option :environment,
         description: 'Run against only specific app tier (dev,qa,uat,prod).',
         short: '-e TAG',
         long: '--environment TAG',
         default: 'prod'

  option :handlers,
         description: 'Handlers to pass into ec2 check populated sources.',
         short: '-h HANDLERS',
         long: '--handlers HANDLERS',
         default: ['pagerduty', 'logstash', 'ec2_instance']


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
      'ttl'    => 600,
      'ttl_status' => 2,
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
      'ttl'    => 600,
      'ttl_status' => 2,
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
      'ttl'    => 600,
      'ttl_status' => 2,
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
      'ttl'    => 600,
      'ttl_status' => 2,
      'output' => "#{self.class.name} UNKNOWN: #{msg}",
      'handlers' => config[:handlers]
    }
    send_client_socket(event.to_json)
  end
  def run
    ec2 = Aws::EC2::Client.new
    instances = ec2.describe_instances(
      filters: [
        
        #removed to allow terminated instances to report to ec2_handler
        #{
        #  name: 'instance-state-name',
        #  values: ['running']
        #},
        {
          name: 'tag:app_tier',
          values: ["#{config[:environment]}"]
        }
      ]
    )
   if instances.reservations.empty?
   message = "No running instances found!"
   @level = 3
   unknown(message)
   exit (3)
   else
   vpcnames = ec2.describe_vpcs(
            filters: [
                    {
                name: 'tag-key',
                values: ['Name']
                    }
            ]
    )
    if vpcnames.vpcs.empty?
    message = "No vpc information found!"
    @level = 3
    unknown(message)
    exit (3)
    else
    vpc_fullname = vpcnames.data[:vpcs].first.tags.find{|tag| tag.key == 'Name' }.value


    @level = 0
    instances.reservations.each do |reservation|
      reservation.instances.each do |instance|
        next unless (instance.instance_type.start_with? 't2.') or (instance.instance_type.start_with? 't3.')

            instancetype = instance.instance_type.partition('.').last
        case instancetype
            when 'nano'
            @creditmax = 144
            when 'micro'
            @creditmax = 288
            when 'small'
            @creditmax = 576
            when 'medium'
            @creditmax = 576
            when 'large'
            @creditmax = 864
            when 'xlarge'
            @creditmax = 2304
            when '2xlarge'
            @creditmax = 4608
         end



        id = instance.instance_id
        availzone = instance.placement.availability_zone
        private_addr = instance.private_ip_address
        result = data id
        tag = instance.tags.find{|tag| tag.key == 'Name'}.value
        source_name = "#{tag}-#{vpc_fullname}-#{private_addr}"
        check_name = "#{tag}_#{availzone}"

        
        if private_addr.nil? or availzone.nil? or tag.nil? or vpc_fullname.nil?
          @output = "one or more fields is still populating."
          puts "#{@output}  private_addr = #{private_addr}, availzone = #{availzone}, tag = #{tag}, vpc_fullname = #{vpc_fullname}"
           exit 1
        end


        unless result.nil?
          criticalbase =  @creditmax.to_f * config[:critical].to_f / 100
          warningbase =  @creditmax.to_f * config[:warning].to_f / 100
          if result < criticalbase && result < warningbase
          msg = "#{tag}-#{vpc_fullname}-#{private_addr} is below critical threshold [#{result} < #{criticalbase}] \n"
           send_critical(source_name, check_name, msg)

          elsif config[:warning] && result < warningbase
           msg = "#{tag}-#{vpc_fullname}-#{private_addr} is below warning threshold [#{result} < #{warningbase}] \n"
           send_warning(source_name, check_name, msg)

          elsif result > warningbase && result > criticalbase
           msg = "#{tag}-#{vpc_fullname}-#{private_addr} CPU Credit usage okay at this time [#{result}] [crit = #{criticalbase}] [warn = #{warningbase}]."
           send_ok(source_name, check_name, msg)
     end
     if @level == 0
     @output = "Check running with no issues"
    end

    if @level == 3
    @output = "No instances were able to be identified"
    end
       end
       end
       end
    ok(@output) if @level == 0
    unknown(message) if @level == 3
     end
     end
  end
 end

