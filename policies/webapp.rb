name 'magento_webapp'

default_source :supermarket, 'https://supermarket.chef.io' do |s|
    s.preferred_for 'resolver', 'lvm', 'apparmor', 'chef-client', 'mysql', 'yum-epel', 'windows', 'trusted_certificate', 'ssh_known_hosts', 'seven_zip', 'php', 'ohai', 'nginx', 'mingw', 'logrotate', 'hostsfile', 'cron', 'build-essential', 'apt'
end

default_source :chef_server, chef_config['chef_server_url'] do |c|
    c.preferred_for 'magento'
end

include_policy 'base', git: 'git@git.zumiez.com:cookbooks/base', path: 'Policyfile.lock.json', branch: 'main'

#cookbook 'magento',        '~> 0.1.8'
cookbook 'magento',	   path: '../'
cookbook 'devops_base',    '~> 0.2.7'
cookbook 'magento_webapp', '~> 0.1.27'
cookbook 'magento_deploy', '~> 0.1.42'
cookbook 'magento_mysql',  '~> 0.1.0'
cookbook 'magento_newrelic', git: 'git@git.zumiez.com:cookbooks/magento_newrelic.git', branch: 'main'
#cookbook 'okta_asa', git: 'https://git.zumiez.com/cookbooks/okta_asa.git', branch: 'attributes-app-implementation'
# cookbook 'newrelic_agent', git: 'https://git.zumiez.com/cookbooks/newrelic_agent.git'

run_list [
    'magento::default',
    'base::default',
    'devops_base::default',
    'devops_base::resolver',
    'magento_webapp::default',
    'magento_deploy::default',
    'magento_mysql::install_client',
    'magento_newrelic::default',
#    'okta_asa::default',
    #    'newrelic_agent::default',
]
