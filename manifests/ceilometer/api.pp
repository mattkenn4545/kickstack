class kickstack::ceilometer::api inherits kickstack::ceilometer {
  if (!$db_host) {
    $unset_parameter = 'db_host'
  } elsif (!$keystone_api_host) {
    $unset_parameter = 'keystone_api_host'
  }

  if $unset_parameter {
    $message = inline_template($unset_parameter_template)
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
