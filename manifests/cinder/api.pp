class kickstack::cinder::api inherits kickstack::cinder {
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
}
