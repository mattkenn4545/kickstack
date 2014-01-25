define kickstack::endpoint (
  $service_password   = false,
  $servicename        = $name,
  $classname          = 'auth'
) {
  if (getvar("kickstack::params::${name}_api_host")) {
    $value = getvar("kickstack::params::${name}_api_host")
  } else {
    $value = $fqdn
  }

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

  kickstack::exportfact { "${servicename}_api_host": }
}
