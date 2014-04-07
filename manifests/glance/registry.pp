class kickstack::glance::registry inherits kickstack::glance {
  if (!$db_host) {
    $unset_parameter = 'db_host'
  } elsif (!$keystone_api_host) {
    $unset_parameter = 'keystone_api_host'
  } elsif (!$glance_registry_host) {
    $unset_parameter = 'glance_registry_host'
    $is_provided = true
  }

  if $unset_parameter {
    $message = inline_template($unset_parameter_template)
    notify { $message: }
  } else {
    include kickstack::glance::config

    include kickstack::glance::db

    include kickstack::keystone

    $sql_connection             = $kickstack::glance::db::sql_connection

    class { '::glance::registry':
      verbose           => $verbose,
      debug             => $debug,
      auth_host         => $keystone_api_host,
      keystone_tenant   => $kickstack::keystone::service_tenant,
      keystone_user     => 'glance',
      keystone_password => $service_password,
      sql_connection    => $sql_connection
    }
  }
}
