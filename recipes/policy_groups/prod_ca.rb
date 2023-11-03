#
# Cookbook:: magento
# Recipe:: staging_zumiez_com
#
# Copyright:: 2019, The Authors, All Rights Reserved.

#================================
#        Shared Config
#================================
shared_config = {
    'devel_stage' => 'production',
    'mage_run_code' => 'base',
    'user' => 'ubuntu',
    'urls' => [
        'www.zumiez.ca',
        'sold.zumiez.ca',
    ],
    'mysql' => {
        'host' => 'mysql_host',
        'username' => 'mysql_user',
        'password' => 'mysql_pass',
        'database' => 'mysql_data',
    },
    'cache' => {
        'host' => 'cache_host',
        'port' => '6380',
        'db' => '1',
    },
    'middleware' => {
      'fqdn' => 'middleware-prod.aws.zumiez.ca',
      'enable_write' => '1', # This existed in mag_webapp cookbook policy file
    },
  }

#================================
#   Dependant Cookbook Configs
#================================
webapp_config = {
    'devel_stage' => shared_config['devel_stage'],
    'user' => shared_config['user'],
    'urls' => shared_config['urls'],
    'mysql' => {
        'host' => shared_config['mysql']['host'],
        'username' => shared_config['mysql']['username'],
        'password' => shared_config['mysql']['password'],
        'database' => shared_config['mysql']['database'],
        'prod' => {
            'write' => {
                'host' => 'prod_host_write',
                'username' => 'prod_user',
                'password' => 'prod_pass',
                'database' => 'prod_data',
            },
            'read' => {
                'host' => 'prod_host_read',
                'username' => 'prod_user',
                'password' => 'prod_pass',
                'database' => 'prod_data',
            },
        },
    },
    'cache' => shared_config['cache'],
    'ssmtp' => {
        'hostname' => 'email.zumiez.com',
        'mailhub' => 'sendgrid_endpoint',
        'AuthUser' => 'sendgrid_user',
        'AuthPass' => 'sendgrid_pass',
        'UseSTARTTLS' => true,
    },
    'middleware' => shared_config['middleware'],
}

deploy_config = {
    'devel_stage' => shared_config['devel_stage'],
    'user' => shared_config['user'],
    'urls' => shared_config['urls'],
    'mysql' => shared_config['mysql'],
    'cache' => shared_config['cache'],
    'redis_session' => {
        'host' => 'cache_host',
        'port' => '6379',
        'db' => '0',
      },
    'full_page_cache' => {
        'host' => 'cache_host',
        'port' => '6380',
        'db' => '2',
    },
    'resque' => {
        'host' => 'cache_host',
        'port' => '6379',
        'workers' => '5',
        'db' => '0',
        'log_level' => '100',
    },
    'middleware' => shared_config['middleware'],
}

cache_config = {}

mysql_config = {
    'devel_stage' => shared_config['devel_stage'],
    'user' => shared_config['user'],
    'root_pass' => 'mysql_pass',
    'data_dir' => '/data',
    'innodb_buffer_pool_size' => '25G',
    'innodb_log_file_size' => '2G',
}

utility_config = {
    'devel_stage' => shared_config['devel_stage'],
    'user' => shared_config['user'],
    'urls' => shared_config['urls'][0],
    #    "ssmtp" => shared_config['ssmtp'],
    #    "mysql" => shared_config['mysql']
}

# In order to use attributes declared within the dependant cookbooks we have to merge their attributes
# with the ones declared within the wrapper cookbook. We retrive the needed configs by parsing the
# run_list and grabbing the name after the '_' for the granular cookbook

run_configs = node.run_list.map { |ele| ele.to_s.split('::')[0].split('_')[1] }

magento_configs = [
    'webapp',
    'deploy',
    'cache',
    'utility',
    'mysql',
    'middleware'
]

run_configs.each do |run_config|
    next if run_config.nil? || ! magento_configs.include?(run_config)

    config = eval("#{run_config}_config")
    cookbook = "magento_#{run_config}"
    node.default[cookbook] = if node[cookbook].nil?
                                 config
                             else
                                 node[cookbook].merge(config)
                             end
end
