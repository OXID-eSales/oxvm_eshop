require 'fileutils'

pwd = File.dirname(File.expand_path(__FILE__))

ENV['BASE_VM_PATH'] = pwd + '/base_vm/'
ENV['VM_PATH'] = pwd
ENV['PLAYBOOK'] = 'oxid'

create_eshop_shared_folder = Proc.new {
  |config, vm_config|

  [:up, :provision].each do |cmd|
    config.trigger.before cmd do
      if !Dir.exists?(vm_config['app_shared_folder']['source'])
        FileUtils::mkdir_p("#{vm_config['app_shared_folder']['source']}")
      end
    end
  end
}

config_hook = [create_eshop_shared_folder]

eval File.read("#{ENV['BASE_VM_PATH']}/Vagrantfile")
