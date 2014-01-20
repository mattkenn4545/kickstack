define kickstack::db (
  $password,
  $allowed_hosts = '%'
) {
  include kickstack::database::install

  $database     = $kickstack::database::server

  $servicename  = $name
  $username     = $name

  if ($password == "${servicename}_dbpass") {
    if ($kickstack::allow_default_passwords) {
      warning("Default password for database ${name}.")
    } else {
      fail("Default password for database ${name} and default passwords are not allowed.")
    }
  }

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
