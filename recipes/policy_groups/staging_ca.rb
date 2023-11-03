#
# Cookbook:: magento
# Recipe:: staging_zumiez_ca
#
# Copyright:: 2019, The Authors, All Rights Reserved.

#================================
#        Shared Config
#================================
shared_config = {
    'devel_stage' => 'staging',
    'mage_run_code' => 'base',
    'user' => 'deploy',
    'urls' => [
        'staging.zumiez.ca',
        'sold.staging.zumiez.ca',
    ],
    'mysql' => {
        'host' => 'staging_host',
        'username' => 'staging_username',
        'password' => 'staging_password',
        'database' => 'staging_database',
    },
    'cache' => {
        'host' => 'staging_cache',
        'port' => 'cache_port',
    },
    'middleware' => {
        'fqdn' => 'middleware.zumiez.ca',
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
                'username' => 'prod_username',
                'password' => 'prod_password',
                'database' => 'prod_database',
            },
            'read' => {
                'host' => 'prod_host_read',
                'username' => 'prod_username',
                'password' => 'prod_password',
                'database' => 'prod_database',
            },
        },
        'preview' => {
            'host' => 'preview_host',
            'username' => 'preview_username',
            'password' => 'preview_password',
            'database' => 'preview_database',
        },
    },
    'cache' => shared_config['cache'],
    'ssmtp' => {
        'hostname' => 'staging.zumiez.com',
        'mailhub' => 'sendgrid_endpoint',
        'AuthUser' => 'sendgrid_user',
        'AuthPass' => 'sendgrid_pass',
        'UseSTARTTLS' => true,
    },
    'atg' => {
        'host' => 'atg_host',
        'user' => 'atg_user',
        'password' => 'atg_pass',
    },
    'endeca' => {
        'host' => 'endeca_host',
        'user' => 'endeca_user',
        'password' => 'endeca_pass',
    },
    'endecanew' => {
        'host' => 'endeca_host',
        'user' => 'endeca_pass',
        'password' => 'endeca_pass',
    },
    'google_ftp' => {
        'host' => 'ftp_host',
        'user' => 'ftp_user',
        'password' => 'ftp_pass',
    },
    'middleware' => shared_config['middleware'],
}

deploy_config = {
    'devel_stage' => shared_config['devel_stage'],
    'user' => shared_config['user'],
    'urls' => shared_config['urls'],
    'mysql' => shared_config['mysql'],
    'cache' => shared_config['cache'],
    'full_page_cache' => {
        'host' => 'cache_host',
        'port' => '6384',
    },
    'redis_session' => {
        'host' => 'cache_host',
        'port' => '6382',
    },
    'resque' => {
        'host' => 'cache_host',
        'port' => '6381',
        'workers' => '16',
        'log_level' => '1',
    },
    'middleware' => shared_config['middleware'],
}

cache_config = {}

mysql_config = {
    'devel_stage' => shared_config['devel_stage'],
    'user' => shared_config['user'],
    'root_pass' => 'mqsl_pass',
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
