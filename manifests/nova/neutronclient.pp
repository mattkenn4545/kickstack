class kickstack::nova::neutronclient inherits kickstack::nova {
  if (!$keystone_api_host) {
    $missing_fact = 'keystone_api_host'
  } elsif (!$neutron_host) {
    $missing_fact = 'neutron_host'
  }

  if $missing_fact {
    $class = $exported_fact_provider[$missing_fact]

    $message = inline_template($missing_fact_template)
    notify { $message: }
  } else {
    include kickstack::nova::config

    include kickstack::neutron
    include kickstack::keystone

    if (defined(Class['::nova'])) {
      class { '::nova::network::neutron':
        neutron_admin_password    => $kickstack::neutron::service_password,
        neutron_auth_strategy     => 'keystone',
        neutron_url               => "http://${neutron_host}:9696",
        neutron_admin_tenant_name => $kickstack::keystone::service_tenant,
        neutron_region_name       => $kickstack::keystone::region,
        neutron_admin_username    => 'neutron',
        neutron_admin_auth_url    => "http://${keystone_api_host}:35357/v2.0",
        security_group_api        => 'neutron'
      }
    } else {
      notify { 'Unable to apply ::nova::network::neutron': }
    }
  }
}
