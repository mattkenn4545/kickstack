class kickstack::horizon (
  $secret_key           = hiera('kickstack::horizon::secret_key',           'horizon_secret_key'),

  # Allow access to Horizon using any host name?
  # Default is false, meaning allow Horizon access only through the
  # FQDN of the dashboard host.
  # Set to true if you want to access by IP address, through an SSH
  # tunnel, etc.
  $allow_any_hostname   = hiera('kickstack::horizon::allow_any_hostname',   false)
) inherits kickstack {
  validate_bool($allow_any_hostname)
}
