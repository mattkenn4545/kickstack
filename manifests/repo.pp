class kickstack::repo inherits kickstack::params {
  class { '::openstack::repo':
    release => $release
  }
}
