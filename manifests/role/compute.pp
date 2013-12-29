class kickstack::role::compute inherits kickstack {
    include kickstack::neutron::agent::l2

    include kickstack::nova::compute
    include kickstack::nova::neutronclient

    include kickstack::ceilometer::agent::compute
}
