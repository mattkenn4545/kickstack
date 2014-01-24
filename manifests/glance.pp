class kickstack::glance (
  $service_password   = 'glance_password'
) inherits kickstack::params {
  $service_name = 'glance'

  if ($service_password == "${service_name}_password") {
    if ($allow_default_passwords) {
      warning(inline_template($default_password_template))
    } else {
      fail(inline_template($default_password_template))
    }
  }
}
