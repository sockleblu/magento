#
# Cookbook:: magento
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

timezone 'UTC'

# If cookbook is being run through Test Kitchen, parse it's suite name
# Chef::Log.fatal(node['name'])
if node.policy_group == 'local'
    #    suite = node['name'].split('-')
    #    group = if suite.include? 'dev'
    #                suite[0..1].join('_')
    #            else
    #                suite[1..3].join('_')
    #            end
    suite = node['name']
    case suite
    when /^.*dev.*$/
        group = 'dev'
    when /^.*preview.*com.*$/
        group = 'test_us'
    when /^.*acceptance.*com.*$/
        group = 'acceptance_us'
    when /^.*staging.*com.*$/
        group = 'staging_us'
    when /^.*prod.*com.*$/
        group = 'prod_us'
    when /^.*preview.*ca.*$/
        group = 'test_ca'
    when /^.*acceptance.*ca.*$/
        group = 'acceptance_ca'
    when /^.*staging.*ca.*$/
        group = 'staging_ca'
    when /^.*prod.*ca.*$/
        group = 'prod_ca'
    end
else
    group = node.policy_group
end

include_recipe "::#{group}"
