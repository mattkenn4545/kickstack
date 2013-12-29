class kickstack::ceilometer::agent::metering inherits kickstack::ceilometer {
  include kickstack::ceilometer::config
  include kickstack::ceilometer::auth

  class { '::ceilometer::collector': } ->
  class { '::ceilometer::agent::central': }
}
