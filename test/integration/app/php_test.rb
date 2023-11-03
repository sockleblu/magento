control 'PHP' do
    impact 0.6
    title 'Configures PHP for all COM environments'
    tag 'magento', 'all', 'zumiez.com', 'com', 'php'

    web_packages = %w(php5-dev php5-xmlrpc php5-mysql php5-curl php5-cli php5-fpm
                      php5-intl php5-gd php5-mcrypt)

    web_packages.each do |pack|
        describe package(pack) do
            it { should be_installed }
        end
    end

    describe file('/etc/php5/fpm/conf.d/05-opcache.ini') do
        it { should exist }
        its('link_path') { should eq '/etc/php5/mods-available/opcache.ini' }
    end

    describe file('/etc/php5/mods-available/redis.ini') do
        it { should exist }
        its('owner') { should eq 'root' }
        its('group') { should eq 'root' }
        its('mode')  { should cmp '0644' }
        its('content') { should match('extension=/usr/lib/php5/20121212/redis.so') }
    end

    describe file('/etc/php5/fpm/conf.d/20-redis.ini') do
        it { should exist }
        its('link_path') { should eq '/etc/php5/mods-available/redis.ini' }
    end

    describe file('/etc/php5/mods-available/mcrypt.ini') do
        it { should exist }
        its('owner') { should eq 'root' }
        its('group') { should eq 'root' }
        its('mode')  { should cmp '0644' }
        its('content') { should match('extension=mcrypt.so') }
    end

    describe file('/etc/php5/fpm/conf.d/20-mcrypt.ini') do
        it { should exist }
        its('link_path') { should eq '/etc/php5/mods-available/mcrypt.ini' }
    end

    describe file('/etc/php5/mods-available/lzf.ini') do
        it { should exist }
        its('owner') { should eq 'root' }
        its('group') { should eq 'root' }
        its('mode')  { should cmp '0644' }
        its('content') { should match('extension=/usr/lib/php5/20121212/lzf.so') }
    end

    describe file('/etc/php5/fpm/conf.d/20-lzf.ini') do
        it { should exist }
        its('link_path') { should eq '/etc/php5/mods-available/lzf.ini' }
    end

    #    if node['virtualization']['system'] == 'docker'
    describe service('php5-fpm') do
        it { should be_installed }
    end
    #    else
    #        describe service('php5-fpm') do
    #            it { should be_installed }
    #            it { should be_enabled }
    #            it { should be_running }
    #        end
    #    end
end
