define kickstack::exportfact {
  include kickstack

  $value = getvar("kickstack::params::${name}")

  if ($value == $fqdn or value == getvar("ipaddress_${kickstack::params::nic_management}") or !$value) {
    ::exportfact::export { "${kickstack::params::kickstack_environment}_${name}":
      value     => $name ? { 'nova_metadata_ip' => getvar("ipaddress_${kickstack::params::nic_management}"),
                             default => $fqdn },
      category  => $kickstack::params::kickstack_environment
    }
  }
}
