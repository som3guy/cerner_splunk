# coding: UTF-8

name 'splunk_monitors'

description 'Set the monitors for splunk'

default_attributes(
  splunk: {
    main_project_index: 'opsinfra',
    monitors: [{
      path: '/var/log/dmesg',
      sourcetype: 'dmesg'
    }]
  }
)
