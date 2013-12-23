define kickstack::db (
  $password,
  $allowed_hosts = '%'
) {
  $database     = $kickstack::database::server

  $servicename  = $name
  $username     = $name

  if ($password == "${servicename}_pass") {
    notify {"${name} is using the default password.  To fix set kickstack::${name}::db::password": }

    if (!$kickstack::params::allow_default_passwords) {
      fail("Default password for '${name}' and default passwords are not allowed.")
    }
  }

  # Configure the service database (classes look like nova::db::mysql or
  # glance::db:postgresql, for example).
  # If running on mysql, set the "allowed_hosts" parameter to % so we
  # can connect to the database from anywhere.
  case $database {
    'mysql': {
      class { "::${servicename}::db::mysql":
        user          => $username,
        password      => $password,
        charset       => 'utf8',
        allowed_hosts => $allowed_hosts
      }
    }
    default: {
      class { "::${servicename}::db::${database}":
        password      => $password
      }
    }
  }
}
