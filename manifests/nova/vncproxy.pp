class kickstack::nova::vncproxy inherits kickstack::nova {
  include kickstack::nova::config

  if (defined(Class['::nova'])) {
    class { '::nova::vncproxy':
      enabled         => true,
      host            => getvar("ipaddress_${nic_management}"),
      ensure_package  => $package_version
    }

    kickstack::exportfact { 'vncproxy_host':
      require         => Class['::nova::vncproxy']
    }

  } else {
    notify { 'Unable to apply ::nova::vncproxy': }
  }
}
