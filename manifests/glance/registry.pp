class kickstack::glance::registry inherits kickstack::glance {
  if (!$db_host) {
    $missing_fact = 'db_host'
  } elsif (!$keystone_api_host) {
    $missing_fact = 'keystone_api_host'
  }

  if $missing_fact {
    $class = $exported_fact_provider[$missing_fact]

    $message = inline_template($missing_fact_template)
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

    # Export the registry host name string for the service
    kickstack::exportfact { 'glance_registry_host':
      require           => Class[ '::glance::registry' ]
    }
  }
}
