class mcelog::params {
  $package_name         = 'mcelog'
  $config_file_path     = '/etc/mcelog/mcelog.conf'
  $config_file_template = 'mcelog/mcelog.conf.erb'

  # MCE is only supported on x86_64
  case $::architecture {
    'x86_64': {}
    default: {
      fail("Module ${module_name} is not supported on architecture: ${::architecture}")
    }
  }
  case $::osfamily {
    'RedHat': {
      if $facts['os']['release']['major'] == 6 {
        $service_name = 'mcelogd'
      } else {
        $service_name = 'mcelog'
      }
    }
    default: {
      fail("Module ${module_name} is not supported on osfamily: ${::osfamily}")
    }
  }
}
