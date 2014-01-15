class kickstack::neutron::agent::metadata inherits kickstack::neutron {
   if (!$auth_host) {
     $missing_fact = 'auth_host'
   } elsif (!$nova_metadata_ip) {
     $missing_fact = 'nova_metadata_ip'
   }

  if $missing_fact {
    $class = $exported_fact_provider[$missing_fact]

    $message = inline_template($missing_fact_template)
    notify { $message: }
  } else {
    include kickstack::neutron::config

    if (defined(Class['::neutron'])) {
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
    } else {
      notify { 'Unable to apply ::neutron::agents::metadata': }
    }
  }
}
