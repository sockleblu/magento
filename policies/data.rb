name 'magento_data'

default_source :supermarket, 'https://supermarket.chef.io' do |s|
    s.preferred_for 'resolver', 'lvm', 'chef-client', 'yum-epel', 'windows', 'trusted_certificate', 'seven_zip', 'php', 'ohai', 'nginx', 'mysql', 'mingw', 'logrotate', 'cron', 'build-essential', 'apt', 'apparmor'
end

default_source :chef_server, chef_config['chef_server_url'] do |c|
    c.preferred_for 'magento'
end

cookbook 'magento',       '~> 0.1.0'
cookbook 'devops_base',   '~> 0.2.8'
cookbook 'magento_mysql', '~> 0.1.26'

run_list [
    'magento::default',
    'devops_base::default',
    'magento_mysql::manage_data_disk',
    'magento_mysql::install_server',
    'magento_mysql::setup_files',
]
