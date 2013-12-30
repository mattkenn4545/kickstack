class kickstack::nova::api inherits kickstack::nova {
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
    include kickstack::nova::config

    include kickstack::neutron
    include kickstack::keystone

    # Stupid hack: Grizzly packages in Ubuntu Cloud Archive
    # require python-eventlet > 0.9, but the python-nova
    # package in UCA does not reflect this
    package { 'python-eventlet':
      ensure => latest
    }

    class { '::nova::api':
      enabled                               => true,
      auth_strategy                         => 'keystone',
      auth_host                             => $auth_host,
      admin_tenant_name                     => $kickstack::keystone::service_tenant,
      admin_user                            => 'nova',
      admin_password                        => $admin_password,
      enabled_apis                          => 'ec2,osapi_compute,metadata',
      neutron_metadata_proxy_shared_secret  => $kickstack::neutron::metadata_secret
    }

    kickstack::endpoint { 'nova':
      service_password  => $admin_password,
      require           => Class['::nova::api']
    }

    kickstack::exportfact::export { 'nova_metadata_ip':
      value     => getvar("ipaddress_${nic_management}"),
      tag       => 'nova',
      require   => Class['::nova::api']
    }
  }
}
