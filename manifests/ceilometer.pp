class kickstack::ceilometer (
  $service_password   = hiera('kickstack::ceilometer::service_password',      'ceilometer_password'),
  $metering_secret    = hiera('kickstack::ceilometer::metering_secret',       'ceilometer_metering_secret')
) inherits kickstack::params {
  $service_name = 'ceilometer'
}
