class kickstack::neutron::agent::metadata inherits kickstack::neutron {
  include kickstack::neutron::config

  include kickstack::keystone

  class { '::neutron::agents::metadata':
    shared_secret     => $metadata_secret,
    auth_password     => $service_password,
    debug             => $debug,
    auth_tenant       => $kickstack::keystone::service_tenant,
    auth_user         => 'neutron',
    auth_url          => "http://${auth_host}:35357/v2.0",
    auth_region       => $kickstack::keystone::region,
    metadata_ip       => $nova_metadata_ip,
    package_ensure    => $package_version,
  }
}
