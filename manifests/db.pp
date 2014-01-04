define kickstack::db (
  $password,
  $allowed_hosts = '%'
) {
  $database     = $kickstack::database::server

  $servicename  = $name
  $username     = $name

  if ($password == "${servicename}_dbpass") {
    warning("${name} is using the default password on ${::hostname}")

    if (!$kickstack::allow_default_passwords) {
      fail("Default password for '${name}' and default passwords are not allowed.")
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
