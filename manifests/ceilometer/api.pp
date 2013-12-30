class kickstack::ceilometer::api inherits kickstack::ceilometer {
  if (!$db_host) {
    $missing_fact = 'db_host'
  } elsif (!$auth_host) {
    $missing_fact = 'auth_host'
  }

  if $missing_fact {
    $class = $exported_fact_provider[$missing_fact]

    if (defined(Class[$class])) {
      $message = inline_template($missing_fact_warn)
      notify { $message: }
    } else {
      $message = inline_template($missing_fact_fail)
      fail($message)
    }
  } else {
    include kickstack::ceilometer::config

    include kickstack::ceilometer::db

    include kickstack::keystone

    $sql_connection = $kickstack::ceilometer::db::sql_connection

    class { '::ceilometer::api':
      keystone_host       => $auth_host,
      keystone_tenant     => $kickstack::keystone::service_tenant,
      keystone_user       => 'ceilometer',
      keystone_password   => $service_password
    }

    kickstack::endpoint { 'ceilometer':
      service_password    => $service_password,
      require             => Class[ '::ceilometer::api' ]
    }

    class { '::ceilometer::db':
      database_connection => $sql_connection
    }
  }
}
