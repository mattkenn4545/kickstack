class kickstack::glance (
  $service_password   = hiera('kickstack::glance::service_password',     'glance_password')
) inherits kickstack {
  $service_name = 'glance'

  if ($service_password == "${service_name}_password") {
    if ($kickstack::allow_default_passwords) {
      warning(inline_template($kickstack::default_password_template))
    } else {
      fail(inline_template($kickstack::default_password_template))
    }
  }
}
