class kickstack::ceilometer (
  $service_password   = 'ceilometer_password',
  $metering_secret    = 'ceilometer_metering_secret'
) inherits kickstack::params {
  $service_name = 'ceilometer'

  if ($service_password == "${service_name}_password") {
    if ($allow_default_passwords) {
      warning(inline_template($default_password_template))
    } else {
      fail(inline_template($default_password_template))
    }
  }
}
