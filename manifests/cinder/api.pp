class kickstack::cinder::api inherits kickstack::cinder {
  include kickstack::cinder::config

  include kickstack::keystone

  class { '::cinder::api':
    keystone_tenant     => $kickstack::keystone::service_tenant,
    keystone_user       => 'cinder',
    keystone_password   => $service_password,
    keystone_auth_host  => $auth_host,
    package_ensure      => $package_version
  }

  kickstack::endpoint { 'cinder':
    service_password    => $service_password,
    require             => Class['::cinder::api']
  }
}
