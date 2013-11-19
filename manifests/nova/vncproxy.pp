class kickstack::nova::vncproxy inherits kickstack {
  include kickstack::nova::config

  class { '::nova::vncproxy':
    enabled         => true,
    host            => getvar("ipaddress_${nic_management}"),
    ensure_package  => $package_version
  }

  kickstack::exportfact::export { 'vncproxy_host':
    value   => $hostname,
    tag     => 'nova',
    require => Class['::nova::vncproxy']
  }
}
