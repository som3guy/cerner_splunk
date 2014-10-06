# coding: UTF-8

name 'splunk_mirrors_cerner'

description 'Configures mirrors for Splunk 4 & 6'

default_attributes(
  splunk: {
    forwarder_root: 'http://repo.release.cerner.corp/nexus/content/sites/splunk/releases',
    package: {
      base_url: 'http://repo.release.cerner.corp/nexus/content/sites/splunk/releases'
    }
  }
)
