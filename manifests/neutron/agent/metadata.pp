class kickstack::neutron::agent::metadata inherits kickstack::neutron {
   if (!$keystone_api_host) {
     $unset_parameter = 'keystone_api_host'
   } elsif (!$nova_metadata_ip) {
     $unset_parameter = 'nova_metadata_ip'
   }

  if $unset_parameter {
    $message = inline_template($unset_parameter_template)
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
        auth_url          => "http://${keystone_api_host}:35357/v2.0",
        auth_region       => $kickstack::keystone::region,
        metadata_ip       => $nova_metadata_ip,
        package_ensure    => $package_version,
      }
    } else {
      notify { 'Unable to apply ::neutron::agents::metadata': }
    }
  }
}
