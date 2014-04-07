class kickstack::glance::api inherits kickstack::glance {
  if (!$db_host) {
    $unset_parameter = 'db_host'
  } elsif (!$glance_registry_host) {
    $unset_parameter = 'glance_registry_host'
  } elsif (!$keystone_api_host) {
    $unset_parameter = 'keystone_api_host'
  }

  if $unset_parameter {
    $message = inline_template($unset_parameter_template)
    notify { $message: }
  } else {
    include kickstack::glance::config

    include kickstack::glance::db

    include kickstack::keystone

    $sql_connection             = $kickstack::glance::db::sql_connection

    class { '::glance::api':
      verbose           => $verbose,
      debug             => $debug,
      auth_type         => 'keystone',
      auth_host         => $keystone_api_host,
      keystone_tenant   => $kickstack::keystone::service_tenant,
      keystone_user     => 'glance',
      keystone_password => $service_password,
      sql_connection    => $sql_connection,
      registry_host     => $glance_registry_host
    }

    kickstack::endpoint { 'glance':
      service_password  => $service_password,
      require           => Class['::glance::api']
    }
  }
}
