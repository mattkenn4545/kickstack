class kickstack::role::network inherits kickstack {
  # Network nodes require a neutron Keystone endpoint.
  # The L2 agents need an SQL connection.
  # The metadata agent also requires the shared secret set by Nova API.

  include kickstack::neutron::agent::dhcp
  include kickstack::neutron::agent::l3
  include kickstack::neutron::agent::l2

  include kickstack::neutron::agent::metadata
}
