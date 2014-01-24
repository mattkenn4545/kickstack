class kickstack::glance::api inherits kickstack::glance {
  if (!$db_host) {
    $missing_fact = 'db_host'
  } elsif (!$glance_registry_host) {
    $missing_fact = 'glance_registry_host'
  } elsif (!$auth_host) {
    $missing_fact = 'auth_host'
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

    class { '::glance::api':
      verbose           => $verbose,
      debug             => $debug,
      auth_type         => 'keystone',
      auth_host         => $auth_host,
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

    kickstack::exportfact { 'glance_api_host':
      require           => Class['::glance::api']
    }
  }
}
