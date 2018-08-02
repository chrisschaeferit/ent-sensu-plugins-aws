## Sensu-Plugins-aws

[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-aws.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-aws)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-aws.svg)](http://badge.fury.io/rb/sensu-plugins-aws)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-aws/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-aws)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-aws/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-aws)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-aws.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-aws)

## Functionality

**check-ec2-cpu_balance.rb**

**check-s3-object.rb**



## Files

* /bin/check-ec2-cpu_balance.rb
* /bin/check-s3-object.rb

## Usage

**handler-ses**

1. Configure [authentication](#authentication)
2. Enable the handler in `/etc/sensu/conf.d/handlers/ses.json`:
```
{
  "handlers": {
    "ses": {
      "type": "pipe",
      "command": "handler-ses.rb"
    }
  }
}
```
3. Configure the handler in `/etc/sensu/conf.d/ses.json`:
```
{
  "ses": {
    "mail_from": "sensu@example.com",
    "mail_to": "monitor@example.com",
    "region": "us-east-1",
    "subscriptions": {
      "subscription_name": {
        "mail_to": "teamemail@example.com"
      }
    }
  }
}
```

**handler-sns**

`handler-sns` can be used to send alerts to Email, HTTP endpoints, SMS, or any other [subscription type](http://docs.aws.amazon.com/sns/latest/dg/welcome.html) supported by SNS.

1. Create an SNS topic and subscription [[Docs]](http://docs.aws.amazon.com/sns/latest/dg/GettingStarted.html)
1. Configure [authentication](#authentication)
2. Enable the handler in `/etc/sensu/conf.d/handlers/sns.json`:
```
{
  "handlers": {
    "sns": {
      "type": "pipe",
      "command": "handler-sns.rb"
    }
  }
}
```
3. Configure the handler in `/etc/sensu/conf.d/sns.json`:
```
{
  "sns": {
    "topic_arn": "arn:aws:sns:us-east-1:111111111111:topic",
    "region": "us-east-1"
  }
}
```
## Installation

[Installation and Setup](http://sensu-plugins.io/docs/installation_instructions.html)

Note:  In addition to the standard installation requirements the installation of this gem will require compiling the nokogiri gem.  Due to this you'll need certain development packages on your system.  On Ubuntu systems install build-essential, libxml2-dev and zlib1g-dev.  On CentOS install gcc and zlib-devel.

## Authentication

AWS credentials are required to execute these checks. Starting with AWS-SDK v2 there are a few
methods of passing credentials to the check:

1. Use a [credential file](http://docs.aws.amazon.com/sdk-for-ruby/v2/developer-guide/setup-config.html#aws-ruby-sdk-credentials-shared). Place the credentials in `~/.aws/credentials`. On Unix-like systems this is going to be `/opt/sensu/.aws/credentials`. Be sure to restrict the file to the `sensu` user.
```
[default]
aws_access_key_id = <access_key>
aws_secret_access_key = <secret_access_key>
```

2. Use an [EC2 instance profile](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html). If the checks are executing on an EC2 instance you can give the instance an IAM role and authentication will be handled automatically.

See the [AWS-SDK docs](http://docs.aws.amazon.com/sdkforruby/api/#Configuration) for more details on
credential configuration.

Some of the checks accept credentials with `aws_access_key` and `aws_secret_access_key` options
however this method is deprecated as it is insecure to pass credentials on the command line. Support
for these options will be removed in future releases.

No matter which authentication method is used you should restrict AWS API access to the minimum required to run the checks. In general this is done by limiting the sensu IAM user/role to the necessary `Describe` calls for the services being checked.
