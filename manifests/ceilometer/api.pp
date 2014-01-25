class kickstack::ceilometer::api inherits kickstack::ceilometer {
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
    include kickstack::ceilometer::config

    if (defined(Class['::ceilometer'])) {
      include kickstack::ceilometer::db

      include kickstack::keystone

      $sql_connection = $kickstack::ceilometer::db::sql_connection

      class { '::ceilometer::api':
        keystone_host       => $keystone_api_host,
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
    } else {
      notify { 'Unable to apply ::ceilometer::api': }
    }
  }
}
