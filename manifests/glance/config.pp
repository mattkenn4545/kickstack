class kickstack::glance::config inherits kickstack::glance::params {
  class { '::glance':
    package_ensure => $package_version
  }
}
