class kickstack::nova::api inherits kickstack::nova {
  if (!$keystone_api_host) {
    $missing_fact = 'keystone_api_host'
  }

  if $missing_fact {
    $class = $exported_fact_provider[$missing_fact]

    $message = inline_template($missing_fact_template)
    notify { $message: }
  } else {
    include kickstack::nova::config

    if (defined(Class['::nova'])) {
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
        auth_host                             => $keystone_api_host,
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
    } else {
      notify { 'Unable to apply ::nova::api': }
    }
  }
}
