class kickstack::ceilometer::agent::compute inherits kickstack::ceilometer {
  include kickstack::ceilometer::config
  include kickstack::ceilometer::auth

  if (defined(Class['::ceilometer']) and
      defined(Class['::ceilometer::agent::auth']) and
      defined(Class['::nova::compute'])) {
    class { '::ceilometer::agent::compute': }
  } else {
    notify { 'Unable to apply ::ceilometer::agent::compute': }
  }
}
