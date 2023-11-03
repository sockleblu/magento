name 'magento_utility'

# Might be able to trim  this ("rsync", "perl", "aws")
default_source :supermarket, 'https://supermarket.chef.io' do |s|
    s.preferred_for 'resolver', 'lvm', 'chef-client', 'apparmor', 'gitlab-ci-runner', 'mysql', 'yum-epel', 'windows', 'trusted_certificate', 'ssh_known_hosts', 'seven_zip', 'php', 'ohai', 'nginx', 'mingw', 'logrotate', 'hostsfile', 'cron', 'build-essential', 'apt', 'rsync', 'perl', 'aws'
end

default_source :chef_server, chef_config['chef_server_url'] do |c|
    c.preferred_for 'magento'
end

include_policy 'base', git: 'git@git.zumiez.com:cookbooks/base', path: 'Policyfile.lock.json', branch: 'main'

cookbook 'magento',         '~> 0.1.5'
cookbook 'devops_base',     '~> 0.2.7'
cookbook 'magento_webapp',  '~> 0.1.27'
cookbook 'magento_deploy',  '~> 0.1.42'
cookbook 'magento_mysql',   '~> 0.1.24'
cookbook 'magento_utility', '~> 0.1.24'

run_list [
    'magento::default',
    'base::default',
    'devops_base::default',
    'devops_base::resolver',
    'magento_webapp::php',
    'magento_webapp::geoip',
    'magento_webapp::magento',
    'magento_deploy::packages',
    'magento_deploy::setup_files',
    'magento_deploy::deploy',
    'magento_mysql::install_client',
    'magento_utility::default',
]
