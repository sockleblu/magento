#
# Cookbook:: magento
# Recipe:: staging_zumiez_com
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
        'staging.zumiez.com',
        'sold.staging.zumiez.com',
    ],
    'ssmtp' => {
        'hostname' => 'staging_host',
        'mailhub' => 'sendgrid_endpoint',
        'AuthUser' => 'sendgrid_user',
        'AuthPass' => 'sendgrid_pass',
        'UseSTARTTLS' => true,
    },
    'mysql' => {
        'host' => 'staging_host',
        'username' => 'staging_user',
        'password' => 'staging_pass',
        'database' => 'staging_data',
    },
    'cache' => {
      'host' => 'staging-cache',
      'port' => '6383',
      'log_level' => '6',
      'retries' => '2',
      'crawl_url_path' => '/home/deploy/urls-for-warming/request_path_urls.txt',
    },
    'middleware' => {
        'fqdn' => 'middleware-staging.zumiez.com',
        'enable_write' => '0',
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
    },
    'cache' => shared_config['cache'],
    'ssmtp' => shared_config['ssmtp'],
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
      'user' => 'endeca_user',
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
    'crypt_key' => 'crypt_key',
    'urls' => shared_config['urls'],
    'mysql' => shared_config['mysql'],
    'cache' => shared_config['cache'],
    'redis_session' => {
      'host' => shared_config['cache']['host'],
      'port' => '6382',
      'max_concurrency' => '48',
      'log_level' => '4',
    },
    'full_page_cache' => {
      'host' => shared_config['cache']['host'],
      'port' => '6384',
      'log_level' => '6',
    },
    'redis_queue' => {
      'host' => shared_config['cache']['host'],
      'port' => '6381',
    },
    'resque' => {
      'host' => shared_config['cache']['host'],
      'port' => '6381',
      'workers' => '5',
      'log_level' => '',
    },
    'middleware' => shared_config['middleware'],
}

middleware_config = {
    'devel_stage' => shared_config['devel_stage'],
    'user' => shared_config['user'],
    'cache_host' => shared_config['cache']['host'],
    'url' => shared_config['middleware']['fqdn'],
}

cache_config = {
    'devel_stage' => shared_config['devel_stage'],
    'maxmemory' => '4GB',
}

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
    'urls' => [ shared_config['urls'][0] ],
    'ssmtp' => shared_config['ssmtp'],
    'mysql' => shared_config['mysql'],
}

# In order to use attributes declared within the dependant cookbooks we have to merge their attributes
# with the ones declared within the wrapper cookbook. We retrive the needed configs by parsing the
# run_list and grabbing the name after the '_' for the granular cookbook

run_configs = node.run_list.map { |ele| ele.to_s.split('::')[0].split('_')[1] }
run_configs = run_configs.uniq

magento_configs = [
    'webapp',
    'deploy',
    'cache',
    'utility',
    'mysql',
    'middleware'
]

log 'run_list' do
    message run_configs.to_s
    level :warn
end

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
