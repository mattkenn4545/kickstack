class kickstack::database (
  $server           = hiera('kickstack::database::server',          'mysql'),
  $root_password    = hiera('kickstack::database::root_password',   'kickstack')
) inherits kickstack {
  if ($root_password == 'kickstack') {
    $base_message = "Default ${server} root password"
    if ($kickstack::allow_default_passwords) {
      warning("${base_message}.")
    } else {
      fail("${base_message} and default passwords are not allowed.")
    }
  }
}
