class kickstack::role::api inherits kickstack {
  include kickstack::glance::api
  include kickstack::cinder::api

  include kickstack::neutron::server
  include kickstack::neutron::plugin

  include kickstack::nova::api
  include kickstack::nova::neutronclient

  include kickstack::heat::api
  include kickstack::ceilometer::api
}
