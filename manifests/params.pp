# @api private
class mcelog::params {
  $package_name         = 'mcelog'
  $config_file_path     = '/etc/mcelog/mcelog.conf'
  $config_file_template = 'mcelog/mcelog.conf.erb'

  # MCE is only supported on x86_64
  case $facts['os']['architecture'] {
    'x86_64': {}
    default: {
      fail("Module ${module_name} is not supported on architecture: ${facts['os']['architecture']}")
    }
  }
  case $facts['os']['family'] {
    'RedHat': {
      $service_name = 'mcelog'
    }
    default: {
      fail("Module ${module_name} is not supported on osfamily: ${facts['os']['family']}")
    }
  }
}
