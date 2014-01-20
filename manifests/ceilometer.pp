class kickstack::ceilometer (
  $service_password   = hiera('kickstack::ceilometer::service_password',      'ceilometer_password'),
  $metering_secret    = hiera('kickstack::ceilometer::metering_secret',       'ceilometer_metering_secret')
) inherits kickstack {
  $service_name = 'ceilometer'

  if ($service_password == "${service_name}_password") {
    if ($kickstack::allow_default_passwords) {
      warning(inline_template($kickstack::default_password_template))
    } else {
      fail(inline_template($kickstack::default_password_template))
    }
  }
}
