# @summary Manage mcelog
#
# @example
#   include ::mcelog
#
# @param ensure
#   Defines state of mcelog. Setting to `absent` will completely remove mcelog
# @param settings
#   Settings hash to be passed to `mcelog.conf` INI file.
#   Keys are the section in `mcelog.log` and empty key is global settings
#   The values are key/value pairs of setting and value under a given section.
# @param service_ensure
#   Service `ensure` value.  Default is based on `ensure` parameter value.
#
class mcelog (
  Enum['present','absent'] $ensure = 'present',
  Hash $settings = {},
  Optional[Enum['running','stopped']] $service_ensure = undef,
) inherits mcelog::params {
  case $ensure {
    'present': {
      $package_ensure = 'present'
      $file_ensure    = 'file'
      $_service_ensure = pick($service_ensure, 'running')
      $service_enable = true
    }
    'absent': {
      $package_ensure = 'absent'
      $file_ensure    = 'absent'
      $_service_ensure = pick($service_ensure, 'stopped')
      $service_enable = false
    }
    default: {
      # Do nothing
    }
  }

  package { 'mcelog':
    ensure => $package_ensure,
    name   => $mcelog::params::package_name,
    before => File['mcelog.conf'],
  }

  file { 'mcelog.conf':
    ensure => $file_ensure,
    path   => $mcelog::params::config_file_path,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Service['mcelog'],
  }

  $mcelog_ini_defaults = {
    'path'    => $mcelog::params::config_file_path,
    'require' => Package['mcelog'],
    'notify'  => Service['mcelog'],
  }
  if $ensure == 'present' {
    create_ini_settings($settings, $mcelog_ini_defaults)
  }

  service { 'mcelog':
    ensure     => $_service_ensure,
    enable     => $service_enable,
    name       => $mcelog::params::service_name,
    hasstatus  => true,
    hasrestart => true,
  }
}
