class mcelog::params {
  $package_name         = 'mcelog'
  $service_name         = 'mcelogd'
  $config_file_template = 'mcelog/mcelog.conf.erb'

  # MCE is only supported on x86_64
  case $::architecture {
    'x86_64': {}
    default: {
      fail("Module ${module_name} is not supported on architecture: ${::architecture}")
    }
  }
  case $::osfamily {
    'redhat': {
      if $::operatingsystemmajrelease == 5 {
        $config_file_path = '/etc/mcelog.conf'
        $service_manage   = false
      } elsif $::operatingsystemmajrelease >= 6 {
        $config_file_path = '/etc/mcelog/mcelog.conf'
        $service_manage   = true
      } else {
        fail("Module ${module_name} is not supported on operatingsystemmajrelease: ${::operatingsystemmajrelease}")
      }
    }
    default: {
      fail("Module ${module_name} is not supported on osfamily: ${::osfamily}")
    }
  }
}
