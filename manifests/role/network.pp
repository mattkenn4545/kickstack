class kickstack::role::network inherits kickstack {
  include kickstack::neutron::agent::dhcp
  include kickstack::neutron::agent::l3
  include kickstack::neutron::agent::l2

  include kickstack::neutron::agent::metadata
}
