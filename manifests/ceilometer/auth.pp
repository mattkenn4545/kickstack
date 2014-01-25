class kickstack::ceilometer::auth inherits kickstack::ceilometer {
  if (!$keystone_api_host) {
    $missing_fact = 'keystone_api_host'
  }

  if $missing_fact {
    $class = $exported_fact_provider[$missing_fact]

    $message = inline_template($missing_fact_template)
    notify { $message: }
  } else {
    include kickstack::ceilometer::config

    if (defined(Class['::ceilometer'])) {
      include kickstack::keystone

      $auth_url         = "http://${keystone_api_host}:5000/v2.0"

      class { '::ceilometer::agent::auth':
        auth_url         => $auth_url,
        auth_region      => $kickstack::keystone::region,
        auth_user        => 'ceilometer',
        auth_password    => $service_password,
        auth_tenant_name => $kickstack::keystone::service_tenant
      }
    } else {
      notify { 'Unable to apply ::ceilometer::agent::auth': }
    }
  }
}
