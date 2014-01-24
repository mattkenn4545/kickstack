class kickstack::heat (
  $service_password               = hiera('kickstack::heat::service_password',              'heat_password'),
  $cfn_service_password           = hiera('kickstack::heat::cfn_service_password',          'cfn_heat_password'),

  # Enabled Heat APIs (comma-separated list of exposed APIs)
  # Can be any combination of 'heat', 'cfn', and 'cloudwatch'
  # Default is just (the native Heat API)
  $apis                           = hiera('kickstack::heat::apis',                          'heat')
) inherits kickstack::params {
  $service_name = 'heat'

  if ($service_password == "${service_name}_password") {
    if ($allow_default_passwords) {
      warning(inline_template($default_password_template))
    } else {
      fail(inline_template($default_password_template))
    }
  }
}
