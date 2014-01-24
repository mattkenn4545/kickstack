class kickstack::database (
  $server           = 'mysql',
  $root_password    = 'kickstack'
) inherits kickstack::params {
  if ($root_password == 'kickstack') {
    $base_message = "Default ${server} root password"
    if ($allow_default_passwords) {
      warning("${base_message}.")
    } else {
      fail("${base_message} and default passwords are not allowed.")
    }
  }
}
