class kickstack::horizon (
  $secret_key           = hiera('kickstack::horizon::secret_key',           'horizon_secret_key'),
  $allow_any_hostname   = hiera('kickstack::horizon::allow_any_hostname',   false)
) inherits kickstack {
  validate_bool($allow_any_hostname)
}
