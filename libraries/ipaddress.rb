# coding: UTF-8

# Cookbook Name:: cerner_splunk
# File Name:: ipaddress.rb

# coding: UTF-8

# Cookbook Name:: cerner_splunk
# File Name:: alerts.rb

require 'json'

module CernerSplunk
  # Module contains functions to configure ipaddresses in a Splunk system
  module Ipaddress
    def self.default_ipaddress(node)
      addresses_hash = node['network']['interfaces'][node['splunk']['mgmt_interface']]['addresses']
      default_ipaddress = addresses_hash.select { |_, v| v['family'] == 'inet' }.keys.first
      default_ipaddress
    end
  end
end