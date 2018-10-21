require "zeployment/version"
require "json"

module Zeployment
  class Aws

    def self.number_of_registered_instances_to_loadbalancer (name_of_load_balancer)
      load_balancer_instances_description_hash = get_load_balancer_instances_description(name_of_load_balancer)
      return load_balancer_instances_description_hash["InstanceStates"].length
    end

    def self.get_load_balancer_instances_description (name_of_load_balancer)
      load_balancers_instance_description_command = get_load_balancers_instances_description_command (name_of_load_balancer)
      load_balancer_instances_description = `#{load_balancers_instance_description_command}`
      return JSON.parse(load_balancer_instances_description)
    end

    def self.get_load_balancers_instances_description_command (name_of_load_balancer)
      return "aws elb describe-instance-health --load-balancer-name #{name_of_load_balancer}"
    end

    def self.number_of_instances_in_service (name_of_load_balancer)
      instances_in_service = 0
      load_balancer_instances_description_hash = get_load_balancer_instances_description(name_of_load_balancer)
      load_balancer_instances_description_hash["InstanceStates"].each do |instance_state|
        if instance_state["State"] == "InService"
          instances_in_service = instances_in_service + 1
        end
      end
      return instances_in_service
    end

    def self.number_of_instances_not_in_service (name_of_load_balancer)
      instances_not_in_service = 0
      load_balancer_instances_description_hash = get_load_balancer_instances_description(name_of_load_balancer)
      load_balancer_instances_description_hash["InstanceStates"].each do |instance_state|
        if instance_state["State"] != "InService"
          instances_not_in_service = instances_not_in_service + 1
        end
      end
      return instances_not_in_service
    end

    def self.get_ip_address_of_ec2_from_id (instance_id)
      instance_description_response = `#{get_ip_address_of_ec2_from_id_command(instance_id)}`
      instance_description_hash = JSON.parse(instance_description_response)
      ip_address = instance_description_hash["Reservations"][0]["Instances"][0]["PublicIpAddress"]
      return ip_address
    end

    def self.get_ip_address_of_ec2_from_id_command (instance_id)
      return "aws ec2 describe-instances --instance-id #{instance_id}"
    end

    def self.deregister_instance_from_load_balancer (name_of_load_balancer, instance_id)
      JSON.parse(`aws elb deregister-instances-from-load-balancer --load-balancer-name #{name_of_load_balancer} --instances #{instance_id}`)
    end

    def self.register_instance_with_load_balancer (name_of_load_balancer, instance_id)
      JSON.parse(`aws elb register-instances-with-load-balancer --load-balancer-name #{name_of_load_balancer} --instances #{instance_id}`)
    end

    def self.get_load_balancer_particular_instance_data (name_of_load_balancer, instance_id)
      load_balancers_instance_description_command = "aws elb describe-instance-health --load-balancer-name #{name_of_load_balancer} --instances #{instance_id}"
      load_balancer_instances_description = `#{load_balancers_instance_description_command}`
      return JSON.parse(load_balancer_instances_description)
    end

    def self.instance_is_in_service? (name_of_load_balancer, instance_id)
      load_balancer_insrance_data_hash = get_load_balancer_particular_instance_data name_of_load_balancer, instance_id
      return load_balancer_insrance_data_hash["InstanceStates"][0]["State"] == "InService"
    end

    def self.deploy (name_of_load_balancer, login_command_without_ip, commands_to_run)
      instances_details = get_load_balancer_instances_description(name_of_load_balancer)
      instances_details["InstanceStates"].each do |instance|
        instance_id = instance["InstanceId"]
        instance_ip = get_ip_address_of_ec2_from_id(instance_id)
        puts instance_ip
        deregister_instance_from_load_balancer(name_of_load_balancer, instance_id)
        login_and_run_commands("#{login_command_without_ip}@#{instance_ip}", commands_to_run)
        register_instance_with_load_balancer(name_of_load_balancer, instance_id)
        wait_till_the_instance_in_service(name_of_load_balancer, instance_id)
        puts ">>>>>>> Instance is in Service now <<<<<<<<<<<<<"
      end
    end

    def self.wait_till_the_instance_in_service(name_of_load_balancer, instance_id)
      while !instance_is_in_service?(name_of_load_balancer, instance_id) do
        puts ">>>>>>> Instance Not in Service <<<<<<<<<<<<<"
      end
    end

    def self.login_and_run_commands(login_command, commands_to_run)
      system("#{login_command} << #{commands_to_run} ")
    end

  end
end
