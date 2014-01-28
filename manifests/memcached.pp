class kickstack::memcached {
  class { '::memcached':
  }

  kickstack::exportfact { 'memcached_hosts': }
}
