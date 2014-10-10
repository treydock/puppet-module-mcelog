class mcelog (
  $ensure = 'present',
  $config_file_template = $::mcelog::params::config_file_template,
) inherits mcelog::params {
  validate_re($ensure, ['^present$', '^absent$'])
  validate_string($config_file_template)

  case $ensure {
    'present': {
      $package_ensure = 'present'
      $file_ensure    = 'file'
      $service_ensure = 'running'
      $service_enable = true
    }
    'absent': {
      $package_ensure = 'absent'
      $file_ensure    = 'absent'
      $service_ensure = 'stopped'
      $service_enable = false
    }
    default: {
      fail("Module ${module_name}: Ensure parameter must be 'present' or 'absent', ${ensure} given.")
    }
  }

  package { $::mcelog::params::package_name:
    ensure => $package_ensure,
    before => File['mcelog.conf'],
  }

  file { 'mcelog.conf':
    ensure  => $file_ensure,
    path    => $::mcelog::params::config_file_path,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template($config_file_template),
  }

  if $mcelog::params::service_manage {
    service { 'mcelog':
      ensure     => $service_ensure,
      name       => $::mcelog::params::service_name,
      hasstatus  => true,
      hasrestart => true,
      enable     => $service_enable,
    }
  }
}
