class kickstack::neutron::server inherits kickstack::neutron {
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
    include kickstack::neutron::config

    if (defined(Class['::neutron'])) {
      include kickstack::neutron::db

      include kickstack::keystone

      $sql_connection       = $kickstack::neutron::db::sql_connection

      class { '::neutron::server':
        auth_tenant     => $kickstack::keystone::service_tenant,
        auth_user       => 'neutron',
        auth_password   => $service_password,
        auth_host       => $keystone_api_host,
        sql_connection  => $sql_connection,
        package_ensure  => $package_version,
        api_workers     => $::processorcount
      }

      if (!defined(Class['kickstack::neutron::agent::l2'])) {
        neutron_plugin_ovs {
          'OVS/enable_tunneling': value => $tenant_network_type ? { 'gre'     => true,
                                                                    default   => false }
        }
      }

      kickstack::endpoint { 'neutron':
        service_password  => $service_password,
        require           => Class[ '::neutron::server' ]
      }
    } else {
      notify { 'Unable to apply ::neutron::server': }
    }
  }
}
