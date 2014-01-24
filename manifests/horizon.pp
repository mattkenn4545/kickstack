class kickstack::horizon (
  $secret_key           = 'horizon_secret_key',

  # Allow access to Horizon using any host name?
  # Default is false, meaning allow Horizon access only through the
  # FQDN of the dashboard host.
  # Set to true if you want to access by IP address, through an SSH
  # tunnel, etc.
  $allow_any_hostname   = false
) inherits kickstack::params {
  validate_bool($allow_any_hostname)

  $service_name = 'horizon'

  if ($secret_key == 'horizon_secret_key') {
    if ($allow_default_passwords) {
      warning(inline_template($default_password_template))
    } else {
      fail(inline_template($default_password_template))
    }
  }
}
