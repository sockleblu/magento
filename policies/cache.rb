name 'magento_cache'

default_source :supermarket, 'https://supermarket.chef.io' do |s|
    s.preferred_for 'resolver', 'chef-client', 'yum-epel', 'php', 'ohai', 'nginx', 'mysql', 'logrotate', 'cron', 'ulimit', 'selinux_policy', 'redisio', 'windows', 'trusted_certificate', 'seven_zip', 'mingw', 'build-essential', 'apt', 'apparmor'
end
default_source :chef_server, chef_config['chef_server_url'] do |c|
    c.preferred_for 'magento'
end

cookbook 'magento',       '~> 0.1.5'
# cookbook 'magento',       path: '../../magento'
cookbook 'devops_base',   '~> 0.2.0'
cookbook 'magento_cache', '~> 0.1.35'
# cookbook 'magento_cache', path: '../../magento_cache'

run_list [
    'magento::default',
    'devops_base::default',
    'devops_base::resolver',
    'magento_cache::default',
]
