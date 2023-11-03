control 'Mysql' do
    impact 0.6
    title 'Configures Mysql Server for staging.zumiez.com'
    tag 'magento', 'staging', 'zumiez.com', 'com', 'mysql'

    packages = %w(
        autoconf
        binutils-doc
        bison
        build-essential
        flex
        gettext
        libmysqlclient-dev
        awscli
        rsync
    )

    packages.each do |pack|
        describe package(pack) do
            it { should be_installed }
        end
    end

    describe file('/etc/mysql-server/conf.d/server.cnf') do
        it { should exist }
        its('owner') { should eq 'mysql' }
        its('group') { should eq 'mysql' }
        its('mode')  { should cmp '0640' }
        its('content') { should match('innodb_buffer_pool_size = 25G') }
        its('content') { should match('innodb_log_file_size    = 2G') }
        its('content') { should match('innodb_log_buffer_size  = 2G') }
        its('content') { should match('server-id=11') }
    end

    describe service('mysql-server') do
        it { should be_installed }
    end
end
