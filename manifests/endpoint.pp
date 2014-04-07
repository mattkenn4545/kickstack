define kickstack::endpoint (
  $service_password   = false,
  $servicename        = $name,
  $classname          = 'auth'
) {
  $value = getvar("kickstack::params::${name}_api_host")
  if ($value) {
    $public_address    = "${value}${kickstack::keystone::public_suffix}"
    $admin_address     = "${value}${kickstack::keystone::admin_suffix}"

    # Installs the service user endpoint.
    if ($name == 'keystone') {
      class { "::keystone::endpoint":
        public_address    => $public_address,
        admin_address     => $admin_address,
        internal_address  => $value,
        region            => $kickstack::keystone::region,
        require           => Class['::keystone']
      }
    } else {
      if (!$service_password) {
        fail("service_password must be sent for ${name} endpoint")
      }

      class { "::${servicename}::keystone::${classname}":
        password          => $service_password,
        public_address    => $public_address,
        admin_address     => $admin_address,
        internal_address  => $value,
        region            => $kickstack::keystone::region,
        require           => Class['::keystone']
      }
    }

    $service_ports = {
      'keystone'    => [ '5000', '35357' ],
      'neutron'     => [ '9696' ],
      'heat'        => [ '8004' ],
      'cinder'      => [ '8776' ],
      'glance'      => [ '9292' ],
      'nova'        => [ '8773', '8774', '8775' ],
      'ceilometer'  => [ '8777' ]
    }

    kickstack::endpoint::balancermember{ $service_ports[$servicename]: service => $servicename }
  } else {
    notify { "Please set '${name}_api_host' or 'haproxy_host'.  This node is eligable to be a '${name}_api_host'.": }
  }
}

define kickstack::endpoint::balancermember ( $service ) {
  @@haproxy::balancermember { "${service}-${name}-${hostname}":
    listening_service => "${service}-${name}",
    server_names      => $hostname,
    ipaddresses       => getvar("ipaddress_${kickstack::params::nic_management}"),
    ports             => $name,
    options           => 'check'
  }
}
