name 'magento_admin'

default_source :supermarket, 'https://supermarket.chef.io' do |s|
    s.preferred_for 'apparmor', 'resolver', 'chef-client', 'mysql', 'yum-epel', 'windows', 'trusted_certificate', 'ssh_known_hosts', 'seven_zip', 'php', 'ohai', 'nginx', 'mingw', 'logrotate', 'hostsfile', 'cron', 'build-essential', 'apt'
end

default_source :chef_server, chef_config['chef_server_url'] do |c|
    c.preferred_for 'magento'
end


include_policy 'base', git: 'git@git.zumiez.com:cookbooks/base', path: 'Policyfile.lock.json', branch: 'main'

cookbook 'magento',        '~> 0.1.5'
cookbook 'devops_base',    '~> 0.2.7'
cookbook 'magento_webapp', '~> 0.1.0'
cookbook 'magento_deploy', '~> 0.1.0'
cookbook 'magento_newrelic', git: 'git@git.zumiez.com:cookbooks/magento_newrelic.git', branch: 'main'

run_list [
    'magento::default',
    'base::default',
    'devops_base::default',
    'devops_base::resolver',
    'magento_webapp::default',
    'magento_deploy::default',
    'magento_newrelic::default',
]
