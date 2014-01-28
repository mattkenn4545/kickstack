define kickstack::exportfact {
  include kickstack

  $value = getvar("kickstack::params::${name}")

  if ($value == $hostname or $value == getvar("ipaddress_${kickstack::params::nic_management}") or !$value or $value == [] or $value == [$hostname]) {
    ::exportfact::export { "${kickstack::params::kickstack_environment}_${name}":
      value     => $name ? { 'nova_metadata_ip' => getvar("ipaddress_${kickstack::params::nic_management}"),
                             default            => $hostname },
      category  => $kickstack::params::kickstack_environment
    }
  }
}
