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
  s.executables = ["check-ec2-cpu_balance.rb".freeze]
  s.files = ["bin/check-ec2-cpu_balance.rb".freeze]
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

