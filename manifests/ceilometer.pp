class kickstack::ceilometer (

) inherits kickstack::params {
  $service_name = 'ceilometer'

  include kickstack::ceilometer::db
}
