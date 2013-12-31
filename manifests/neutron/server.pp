class kickstack::neutron::server inherits kickstack::neutron {
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
    include kickstack::neutron::config

    if (defined(Class['::neutron'])) {
      include kickstack::neutron::db

      include kickstack::keystone

      $sql_connection       = $kickstack::neutron::db::sql_connection

      class { '::neutron::server':
        auth_tenant     => $kickstack::keystone::service_tenant,
        auth_user       => 'neutron',
        auth_password   => $service_password,
        auth_host       => $auth_host,
        sql_connection  => $sql_connection,
        package_ensure  => $package_version
      }

      kickstack::endpoint { 'neutron':
        service_password  => $service_password,
        require           => Class[ '::neutron::server' ]
      }

      kickstack::exportfact::export { 'neutron_host':
        value             => $fqdn,
        tag               => 'neutron',
        require           => Class[ '::neutron::server' ]
      }
    } else {
      notify { 'Unable to apply ::neutron::server': }
    }
  }
}
