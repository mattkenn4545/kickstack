class kickstack::role::infrastructure inherits kickstack {
  include kickstack::rpc
  include kickstack::database

  include kickstack::keystone
  include kickstack::keystone::db

  include kickstack::glance
  include kickstack::glance::db

  include kickstack::cinder
  include kickstack::cinder::db

  include kickstack::neutron
  include kickstack::neutron::db

  include kickstack::nova
  include kickstack::nova::db

  if $heat_apis {
    include kickstack::heat
    include kickstack::heat::db
  }

  include kickstack::ceilometer
  include kickstack::ceilometer::db
}
