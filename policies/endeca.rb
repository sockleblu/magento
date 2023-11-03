name 'magento_endeca'

default_source :supermarket, 'https://supermarket.chef.io' do |s|
    s.preferred_for 'resolver', 'lvm', 'apparmor', 'chef-client', 'mysql', 'yum-epel', 'windows', 'trusted_certificate', 'ssh_known_hosts', 'seven_zip', 'php', 'ohai', 'nginx', 'mingw', 'logrotate', 'hostsfile', 'cron', 'build-essential', 'apt'
end

default_source :chef_server, chef_config['chef_server_url'] do |c|
    c.preferred_for 'magento'
end

cookbook 'magento',        '~> 0.1.21'
cookbook 'devops_base',    '~> 0.2.7'
cookbook 'magento_endeca', git: 'git@git.zumiez.com:cookbooks/magento_endeca.git'

run_list [
    'magento::default',
    'devops_base::default',
    'devops_base::resolver',
    'magento_endeca::default'
]
