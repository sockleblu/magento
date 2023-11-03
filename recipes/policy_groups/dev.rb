#
# Cookbook:: magento
# Recipe:: zumiez_dev
#
# Copyright:: 2019, The Authors, All Rights Reserved.

#================================
#        Shared Config
#================================
shared_config = {
    'devel_stage' => 'dev',
    'user' => 'deploy',
    'urls' => [
        'dev.zumiez.ca',
        'dev.zumiez.com',
        'sold.dev.zumiez.ca',
        'sold.dev.zumiez.com',
        'middleware.zumiez.dev',
    ],
    'mysql' => {
        'host' => '127.0.0.1',
        'username' => 'zumiez',
        'password' => 'msql_pass',
        'database' => 'zumiez_development',
    },
    'cache' => {
        'host' => '127.0.0.1',
        'port' => '6383',
        'log_level' => '6',
    },
    'middleware' => {
        'fqdn' => 'middleware.zumiez.dev',
        'enable_write' => '1',
    },
}

#================================
#   Dependant Cookbook Configs
#================================

webapp_config = shared_config

deploy_config = {
    'devel_stage' => shared_config['devel_stage'],
    'user' => shared_config['user'],
    'urls' => shared_config['urls'],
    'mysql' => shared_config['mysql'],
    'cache' => shared_config['cache'],
    'redis_session' => {
        'host' => '127.0.0.1',
        'port' => '6382',
    },
    'full_page_cache' => {
        'host' => '127.0.0.1',
        'port' => '6384',
        'log_level' => '6',
    },
    'resque' => {
        'host' => '127.0.0.1',
        'port' => '6381',
        'workers' => '1',
    },
    'middleware' => shared_config['middleware'],
}

cache_config = {}

mysql_config = {
    'devel_stage' => shared_config['devel_stage'],
    'user' => shared_config['user'],
    #    "root_pass" => "VZ5FBsVwhBsbvYuVtCrmhAVd",
    #    "data_dir" => "/data",
    #    "innodb_buffer_pool_size" => "25G",
    #    "innodb_log_file_size" => "2G"
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
