class kickstack::nova::neutronclient inherits kickstack::nova {
  include kickstack::nova::config

  include kickstack::neutron
  include kickstack::keystone

  class { '::nova::network::neutron':
    neutron_admin_password    => $kickstack::neutron::service_password,
    neutron_auth_strategy     => 'keystone',
    neutron_url               => "http://${neutron_host}:9696",
    neutron_admin_tenant_name => $kickstack::keystone::service_tenant,
    neutron_region_name       => $kickstack::keystone::region,
    neutron_admin_username    => 'neutron',
    neutron_admin_auth_url    => "http://${auth_host}:35357/v2.0",
    security_group_api        => 'neutron'
  }
}
