class kickstack::glance::config inherits kickstack::glance {
  class { '::glance':
    package_ensure => $package_version
  }
}
