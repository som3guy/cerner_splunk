# coding: UTF-8
#
# Cookbook Name:: cerner_splunk
# File Name:: splunk_template.rb
# HWR for configuring Splunk.

require 'chef/resource/template'
require 'chef/mixin/securable'
require_relative 'lwrp'

class Chef
  class Resource
    # Heavyweight Resource for Splunk conf files
    class SplunkTemplate < Chef::Resource::Template
      include Chef::Mixin::Securable
      extend CernerSplunk::LWRP::DelayableAttribute unless defined? delayable_attribute

      provides :splunk_template, on_platforms: :all

      # rubocop:disable MethodLength
      def initialize(name, run_context = nil)
        super
        @resource_name = :splunk_template
        @variables = nil
        @fail_unknown = true
        backup false
        cookbook 'cerner_splunk'
        source 'generic.conf.erb'
        user node[:splunk][:user]
        group node[:splunk][:group]
        mode '0600'

        # If resource name is unambiguous, default values
        case name
        when /^system\/(.+\.conf)$/
          @path = "etc/system/local/#{Regexp.last_match[1]}"
        when %r{^((?:master-)?app)s?/([^/]+)/(.+\.conf)$}
          @path = "etc/#{Regexp.last_match[1]}s/#{Regexp.last_match[2]}/local/#{Regexp.last_match[3]}"
        end
      end
      # rubocop:enable MethodLength

      delayable_attribute :stanzas, default: {}, kind_of: Hash

      def variables(args = nil)
        val = set_or_return(:variables, args, kind_of: [Hash])
        if args || val
          val
        else
          { stanzas: stanzas }
        end
      end

      def fail_unknown(args = nil)
        set_or_return(:fail_unknown, args, kind_of: [TrueClass, FalseClass])
      end

      def after_created
        @path = "#{node[:splunk][:home]}/#{@path}"

        config_file = ::File.basename(@path)
        return if KNOWN_CONFIG_FILES.include? config_file
        message = "#{config_file} is not known to this resource. Check spelling or submit a pull request."
        Chef::Log.warn message unless fail_unknown
        fail Exceptions::ValidationFailed, "#{message}\nKnown files are:\n\t#{KNOWN_CONFIG_FILES.join("\n\t")}" if fail_unknown
      end

      KNOWN_CONFIG_FILES = %w(
        alert_actions.conf
        authentication.conf
        authorize.conf
        indexes.conf
        inputs.conf
        outputs.conf
        server.conf
        user-prefs.conf
        ui-prefs.conf
      )
    end
  end
end
