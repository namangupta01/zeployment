[![Gem Version](https://badge.fury.io/rb/zeployment.svg)](https://badge.fury.io/rb/zeployment)

# Zeployment

Zeployment is a gem that provides functions as a wrapper to aws-cli and also to perform certain deployment functionality like zero downtime deployment which includes deregistering-deploying-registering of instances from load balancer.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'zeployment'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zeployment

## Getting Started
1. Install aws-cli on the system [Click here for Docs](https://docs.aws.amazon.com/cli/latest/userguide/installing.html "Click here for Docs")
2. Set aws configuration [Docs](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html "Docs")
(Now you are good to go)

## Usage
- To get the number of registered instance to the loadbalancer just use the method `number_of_registered_instances_to_loadbalancer` and pass the load balancer name as argument name and output will be the number of instances registered to the loadbalancer.
```ruby
Zeployment::Aws.number_of_registered_instances_to_loadbalancer (name_of_load_balancer)
```

- To Get the load balancer instances description i.e the description of each instances registered with the load balancer use the following method.
```ruby
Zeployment::Aws.get_load_balancer_instances_description (name_of_load_balancer)
```

- To get the number of instances regsitered with loadbalancer that is in service use the method name `number_of_instances_in_service` with the `load balancer name` as argument 
```ruby
Zeployment::Aws.number_of_instances_in_service (name_of_load_balancer)
```
- To get the number of instances regsitered with loadbalancer that is not in service use the method name `number_of_instances_not_in_service` with the `load balancer name` as argument 
```ruby
Zeployment::Aws.number_of_instances_not_in_service (name_of_load_balancer)
```
- To get the public ip address of the aws ec2 machine using the `instance id` use the method name `get_ip_address_of_ec2_from_id` and pass instance id as argument.
```ruby
Zeployment::Aws.get_ip_address_of_ec2_from_id (instance_id)
```

- To deregister ec2 instance from load balancer use the method `deregister_instance_from_load_balancer` and pass `name of load balancer` as first argument and `instance id` as second argument.
```ruby
Zeployment::Aws.deregister_instance_from_load_balancer (name_of_load_balancer, instance_id)
```
- To register ec2 instance with the load balancer use the method `register_instance_with_load_balancer` and pass `name of load balancer` as first argument and `instance id` as second argument.
```ruby
Zeployment::Aws.register_instance_with_load_balancer (name_of_load_balancer, instance_id)
```
- To get the particular instance status related to loadbalancer use the method `get_load_balancer_particular_instance_data` and pass `name of load balancer` as first argument and `instance id` as second argument.
```ruby
Zeployment::Aws.get_load_balancer_particular_instance_data (name_of_load_balancer, instance_id)
```
- To check if the instance is in service use the method `instance_is_in_service?` and pass `name of load balancer` as first argument and `instane id` as second argument.
```ruby
Zeployment::Aws.instance_is_in_service? (name_of_load_balancer, instance_id)
```
- To perform zero downtime deployment use the method `deploy` and pass the `name of load balancer` as first argument and `login command before ip address` as second argument and  also the commands to run for performing deployment after logging in into the machine.
```ruby
Zeployment::Aws.deploy (name_of_load_balancer, login_command_without_ip, commands_to_run)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/zeployment. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Zeployment project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/zeployment/blob/master/CODE_OF_CONDUCT.md).

