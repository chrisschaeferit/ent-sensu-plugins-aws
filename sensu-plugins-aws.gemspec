# -*- encoding: utf-8 -*-
# stub: sensu-plugins-aws 12.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "sensu-plugins-aws".freeze
  s.version = "12.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "development_status" => "active", "maintainer" => "sensu-plugin", "production_status" => "unstable - testing recommended", "release_draft" => "false", "release_prerelease" => "false" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Sensu-Plugins and contributors".freeze]
  s.date = "2018-06-22"
  s.description = "This plugin provides native AWS instrumentation\n                              for monitoring and metrics collection, including:\n                              health and metrics for various AWS services, such\n                              as EC2, RDS, ELB, and more, as well as handlers\n                              for EC2, SES, and SNS.".freeze
  s.email = "<sensu-users@googlegroups.com>".freeze
  s.executables = ["check-alb-target-group-health.rb".freeze, "check-asg-instances-created.rb".freeze, "check-asg-instances-inservice.rb".freeze, "check-autoscaling-cpucredits.rb".freeze, "check-beanstalk-elb-metric.rb".freeze, "check-beanstalk-health.rb".freeze, "check-certificate-expiry.rb".freeze, "check-cloudfront-tag.rb".freeze, "check-cloudwatch-alarm.rb".freeze, "check-cloudwatch-alarms.rb".freeze, "check-cloudwatch-composite-metric.rb".freeze, "check-cloudwatch-metric.rb".freeze, "check-configservice-rules.rb".freeze, "check-dynamodb-capacity.rb".freeze, "check-dynamodb-throttle.rb".freeze, "check-ebs-burst-limit.rb".freeze, "check-ebs-snapshots.rb".freeze, "check-ec2-cpu_balance.rb".freeze, "check-ec2-filter.rb".freeze, "check-ec2-network.rb".freeze, "check-ecs-service-health.rb".freeze, "check-eip-allocation.rb".freeze, "check-elasticache-failover.rb".freeze, "check-elb-certs.rb".freeze, "check-elb-health-fog.rb".freeze, "check-elb-health-sdk.rb".freeze, "check-elb-health.rb".freeze, "check-elb-instances-inservice.rb".freeze, "check-elb-latency.rb".freeze, "check-elb-nodes.rb".freeze, "check-elb-sum-requests.rb".freeze, "check-emr-cluster.rb".freeze, "check-emr-steps.rb".freeze, "check-eni-status.rb".freeze, "check-instance-events.rb".freeze, "check-instance-health.rb".freeze, "check-instance-reachability.rb".freeze, "check-instances-count.rb".freeze, "check-kms-key.rb".freeze, "check-rds-events.rb".freeze, "check-rds-pending.rb".freeze, "check-rds.rb".freeze, "check-redshift-events.rb".freeze, "check-reserved-instances.rb".freeze, "check-route.rb".freeze, "check-route53-domain-expiration.rb".freeze, "check-s3-bucket-visibility.rb".freeze, "check-s3-bucket.rb".freeze, "check-s3-object.rb".freeze, "check-s3-tag.rb".freeze, "check-sensu-client.rb".freeze, "check-ses-limit.rb".freeze, "check-ses-statistics.rb".freeze, "check-sns-subscriptions.rb".freeze, "check-sqs-messages.rb".freeze, "check-subnet-ip-consumption.rb".freeze, "check-trustedadvisor-service-limits.rb".freeze, "check-vpc-nameservers.rb".freeze, "check-vpc-vpn.rb".freeze, "handler-ec2_node.rb".freeze, "handler-scale-asg-down.rb".freeze, "handler-scale-asg-up.rb".freeze, "handler-ses.rb".freeze, "handler-sns.rb".freeze, "metrics-asg.rb".freeze, "metrics-autoscaling-instance-count.rb".freeze, "metrics-billing.rb".freeze, "metrics-cloudfront.rb".freeze, "metrics-ec2-count.rb".freeze, "metrics-ec2-filter.rb".freeze, "metrics-elasticache.rb".freeze, "metrics-elb.rb".freeze, "metrics-emr-steps.rb".freeze, "metrics-rds.rb".freeze, "metrics-s3.rb".freeze, "metrics-ses.rb".freeze, "metrics-sqs.rb".freeze, "metrics-waf.rb".freeze]
  s.files = ["bin/check-alb-target-group-health.rb".freeze, "bin/check-asg-instances-created.rb".freeze, "bin/check-asg-instances-inservice.rb".freeze, "bin/check-autoscaling-cpucredits.rb".freeze, "bin/check-beanstalk-elb-metric.rb".freeze, "bin/check-beanstalk-health.rb".freeze, "bin/check-certificate-expiry.rb".freeze, "bin/check-cloudfront-tag.rb".freeze, "bin/check-cloudwatch-alarm.rb".freeze, "bin/check-cloudwatch-alarms.rb".freeze, "bin/check-cloudwatch-composite-metric.rb".freeze, "bin/check-cloudwatch-metric.rb".freeze, "bin/check-configservice-rules.rb".freeze, "bin/check-dynamodb-capacity.rb".freeze, "bin/check-dynamodb-throttle.rb".freeze, "bin/check-ebs-burst-limit.rb".freeze, "bin/check-ebs-snapshots.rb".freeze, "bin/check-ec2-cpu_balance.rb".freeze, "bin/check-ec2-filter.rb".freeze, "bin/check-ec2-network.rb".freeze, "bin/check-ecs-service-health.rb".freeze, "bin/check-eip-allocation.rb".freeze, "bin/check-elasticache-failover.rb".freeze, "bin/check-elb-certs.rb".freeze, "bin/check-elb-health-fog.rb".freeze, "bin/check-elb-health-sdk.rb".freeze, "bin/check-elb-health.rb".freeze, "bin/check-elb-instances-inservice.rb".freeze, "bin/check-elb-latency.rb".freeze, "bin/check-elb-nodes.rb".freeze, "bin/check-elb-sum-requests.rb".freeze, "bin/check-emr-cluster.rb".freeze, "bin/check-emr-steps.rb".freeze, "bin/check-eni-status.rb".freeze, "bin/check-instance-events.rb".freeze, "bin/check-instance-health.rb".freeze, "bin/check-instance-reachability.rb".freeze, "bin/check-instances-count.rb".freeze, "bin/check-kms-key.rb".freeze, "bin/check-rds-events.rb".freeze, "bin/check-rds-pending.rb".freeze, "bin/check-rds.rb".freeze, "bin/check-redshift-events.rb".freeze, "bin/check-reserved-instances.rb".freeze, "bin/check-route.rb".freeze, "bin/check-route53-domain-expiration.rb".freeze, "bin/check-s3-bucket-visibility.rb".freeze, "bin/check-s3-bucket.rb".freeze, "bin/check-s3-object.rb".freeze, "bin/check-s3-tag.rb".freeze, "bin/check-sensu-client.rb".freeze, "bin/check-ses-limit.rb".freeze, "bin/check-ses-statistics.rb".freeze, "bin/check-sns-subscriptions.rb".freeze, "bin/check-sqs-messages.rb".freeze, "bin/check-subnet-ip-consumption.rb".freeze, "bin/check-trustedadvisor-service-limits.rb".freeze, "bin/check-vpc-nameservers.rb".freeze, "bin/check-vpc-vpn.rb".freeze, "bin/handler-ec2_node.rb".freeze, "bin/handler-scale-asg-down.rb".freeze, "bin/handler-scale-asg-up.rb".freeze, "bin/handler-ses.rb".freeze, "bin/handler-sns.rb".freeze, "bin/metrics-asg.rb".freeze, "bin/metrics-autoscaling-instance-count.rb".freeze, "bin/metrics-billing.rb".freeze, "bin/metrics-cloudfront.rb".freeze, "bin/metrics-ec2-count.rb".freeze, "bin/metrics-ec2-filter.rb".freeze, "bin/metrics-elasticache.rb".freeze, "bin/metrics-elb.rb".freeze, "bin/metrics-emr-steps.rb".freeze, "bin/metrics-rds.rb".freeze, "bin/metrics-s3.rb".freeze, "bin/metrics-ses.rb".freeze, "bin/metrics-sqs.rb".freeze, "bin/metrics-waf.rb".freeze]
  s.homepage = "https://github.com/chrisschaeferit/sensu-plugins-aws".freeze
  s.licenses = ["MIT".freeze]
  s.post_install_message = "You can use the embedded Ruby by setting EMBEDDED_RUBY=true in /etc/default/sensu".freeze
  s.required_ruby_version = Gem::Requirement.new(">= 2.1.0".freeze)
  s.rubygems_version = "2.6.14".freeze
  s.summary = "Sensu plugins for working with an AWS environment".freeze

  s.installed_by_version = "2.6.14" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sensu-plugin>.freeze, ["~> 2.0"])
      s.add_runtime_dependency(%q<aws-sdk>.freeze, ["~> 3.0"])
      s.add_runtime_dependency(%q<aws-sdk-v1>.freeze, ["= 1.66.0"])
      s.add_runtime_dependency(%q<erubis>.freeze, ["= 2.7.0"])
      s.add_runtime_dependency(%q<fog>.freeze, ["= 1.32.0"])
      s.add_runtime_dependency(%q<fog-core>.freeze, ["= 1.43.0"])
      s.add_runtime_dependency(%q<rest-client>.freeze, ["= 1.8.0"])
      s.add_runtime_dependency(%q<right_aws>.freeze, ["= 3.1.0"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.7"])
      s.add_development_dependency(%q<codeclimate-test-reporter>.freeze, ["~> 0.4"])
      s.add_development_dependency(%q<github-markup>.freeze, ["~> 1.3"])
      s.add_development_dependency(%q<pry>.freeze, ["~> 0.10"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.5"])
      s.add_development_dependency(%q<redcarpet>.freeze, ["~> 3.2"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.4"])
      s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.51.0"])
      s.add_development_dependency(%q<yard>.freeze, ["~> 0.9.11"])
    else
      s.add_dependency(%q<sensu-plugin>.freeze, ["~> 2.0"])
      s.add_dependency(%q<aws-sdk>.freeze, ["~> 3.0"])
      s.add_dependency(%q<aws-sdk-v1>.freeze, ["= 1.66.0"])
      s.add_dependency(%q<erubis>.freeze, ["= 2.7.0"])
      s.add_dependency(%q<fog>.freeze, ["= 1.32.0"])
      s.add_dependency(%q<fog-core>.freeze, ["= 1.43.0"])
      s.add_dependency(%q<rest-client>.freeze, ["= 1.8.0"])
      s.add_dependency(%q<right_aws>.freeze, ["= 3.1.0"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.7"])
      s.add_dependency(%q<codeclimate-test-reporter>.freeze, ["~> 0.4"])
      s.add_dependency(%q<github-markup>.freeze, ["~> 1.3"])
      s.add_dependency(%q<pry>.freeze, ["~> 0.10"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.5"])
      s.add_dependency(%q<redcarpet>.freeze, ["~> 3.2"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.4"])
      s.add_dependency(%q<rubocop>.freeze, ["~> 0.51.0"])
      s.add_dependency(%q<yard>.freeze, ["~> 0.9.11"])
    end
  else
    s.add_dependency(%q<sensu-plugin>.freeze, ["~> 2.0"])
    s.add_dependency(%q<aws-sdk>.freeze, ["~> 3.0"])
    s.add_dependency(%q<aws-sdk-v1>.freeze, ["= 1.66.0"])
    s.add_dependency(%q<erubis>.freeze, ["= 2.7.0"])
    s.add_dependency(%q<fog>.freeze, ["= 1.32.0"])
    s.add_dependency(%q<fog-core>.freeze, ["= 1.43.0"])
    s.add_dependency(%q<rest-client>.freeze, ["= 1.8.0"])
    s.add_dependency(%q<right_aws>.freeze, ["= 3.1.0"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.7"])
    s.add_dependency(%q<codeclimate-test-reporter>.freeze, ["~> 0.4"])
    s.add_dependency(%q<github-markup>.freeze, ["~> 1.3"])
    s.add_dependency(%q<pry>.freeze, ["~> 0.10"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.5"])
    s.add_dependency(%q<redcarpet>.freeze, ["~> 3.2"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.4"])
    s.add_dependency(%q<rubocop>.freeze, ["~> 0.51.0"])
    s.add_dependency(%q<yard>.freeze, ["~> 0.9.11"])
  end
end

