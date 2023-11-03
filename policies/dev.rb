name 'magento_dev'

default_source :supermarket, 'https://supermarket.chef.io' do |s|
    s.preferred_for 'resolver', 'lvm', 'ulimit', 'selinux_policy', 'redisio', 'chef-client', 'apparmor', 'mysql', 'yum-epel', 'windows', 'trusted_certificate', 'ssh_known_hosts', 'seven_zip', 'php', 'ohai', 'nginx', 'mingw', 'logrotate', 'hostsfile', 'cron', 'build-essential', 'apt'
end

default_source :chef_server, chef_config['chef_server_url'] do |c|
    c.preferred_for 'magento'
end

cookbook 'magento',        '~> 0.1.0'
cookbook 'devops_base',    '~> 0.1.0'
cookbook 'magento_webapp', '~> 0.1.0'
cookbook 'magento_deploy', '~> 0.1.0'
cookbook 'magento_cache', '~> 0.1.35'
cookbook 'seven_zip',      '~> 3.2.0'

run_list [
    'magento::default',
    'devops_base::default',
    'magento_webapp::default',
    'magento_deploy::default',
    'magento_cache::default',
    'magento_cache::middleware',
    'magento_mysql::install_server',
    'magento_mysql::setup_files',
    'magento_mysql::install_dev_dbs',
]
