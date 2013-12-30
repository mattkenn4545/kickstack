class kickstack::ceilometer::agent::metering inherits kickstack::ceilometer {
  include kickstack::ceilometer::config
  include kickstack::ceilometer::auth

  if (defined(Class['::ceilometer']) and defined(Class['::ceilometer::agent::auth'])) {
    class { '::ceilometer::collector': } ->
    class { '::ceilometer::agent::central': }
  } else {
    notify { 'Unable to apply ::ceilometer::collector and ::ceilometer::agent::central': }
  }
}
