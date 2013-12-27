class kickstack::neutron::server inherits kickstack::neutron {
  include kickstack::neutron::config

  include kickstack::keystone

  class { '::neutron::server':
    auth_tenant     => $kickstack::keystone::service_tenant,
    auth_user       => 'neutron',
    auth_password   => $service_password,
    auth_host       => $auth_host,
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
}
