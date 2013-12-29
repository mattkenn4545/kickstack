class kickstack::ceilometer::auth inherits kickstack::ceilometer {
  include kickstack::keystone

  $auth_url         = "http://${auth_host}:5000/v2.0"

  class { '::ceilometer::agent::auth':
    auth_url         => $auth_url,
    auth_region      => $kickstack::keystone::region,
    auth_user        => 'ceilometer',
    auth_password    => $service_password,
    auth_tenant_name => $kickstack::keystone::service_tenant
  }
}
