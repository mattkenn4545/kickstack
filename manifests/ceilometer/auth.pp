class kickstack::ceilometer::auth inherits kickstack::ceilometer {
   if (!$auth_host) {
     $missing_fact = 'auth_host'
   }

  if $missing_fact {
    $class = $exported_fact_provider[$missing_fact]

    if (defined(Class[$class])) {
      $message = inline_template($missing_fact_template)
      notify { $message: }
    } else {
      $message = inline_template($missing_fact_fail)
      fail($message)
    }
  } else {
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
}
