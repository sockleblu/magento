#
# Cookbook:: magento
# Recipe:: staging_zumiez_com
#
# Copyright:: 2019, The Authors, All Rights Reserved.

#================================
#        Shared Config
#================================
shared_config = {
    'devel_stage' => 'preview',
    'mage_run_code' => 'base',
    'user' => 'ubuntu',
    'urls' => [
        'preview.zumiez.com', # this for magento_test
        # "preview1.zumiez.com",
        'previewsold.zumiez.com', # ,
        # "preview5.zumiez.com",
        # "previewsold5.zumiez.com"
    ],
    'mysql' => {
        'host' => "preview_host",
        'username' => 'preview_user',
        'password' => "preview_password",
        'database' => 'preview_database',
    },
    'cache' => {
        'host' => 'cache-preview.aws.zumiez.com',
        'port' => '6701',
    },
    'middleware' => {
        'fqdn' => "middleware-preview.aws.zumiez.com'",
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
        'preview' => {
            'host' => 'preview_host',
            'username' => 'preview_user',
            'password' => 'preview_pass',
            'database' => 'preview_data',
        },
    },
    # .comche" => shared_config[.comche'],
    'ssmtp' => {
        'hostname' => 'smtp_host',
        'mailhub' => 'smtp_endpoint',
        'AuthUser' => 'smtp_user',
        'AuthPass' => 'smtp_pass',
        'UseSTARTTLS' => true,
    },
}

deploy_config = {
    'devel_stage' => shared_config['devel_stage'],
    'user' => shared_config['user'],
    'urls' => shared_config['urls'],
    'mysql' => shared_config['mysql'],
    'cache' => shared_config['cache'],
    'full_page_cacheche' => {
        'host' => 'cache-preview.aws.zumiez.com',
        'port' => '6801',
    },
    'redis_session' => {
        'host' => 'cache-preview.aws.zumiez.com',
        'port' => '6601',
    },
    'resque' => {
        'host' => 'cache-preview.aws.zumiez.com',
        'port' => '6501',
        'workers' => '1',
        # "log_level" => "1"
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
