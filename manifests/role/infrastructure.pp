class kickstack::role::infrastructure inherits kickstack {
  include kickstack::rpc

  include kickstack::database::install

  include kickstack::keystone::db
  include kickstack::glance::db
  include kickstack::cinder::db
  include kickstack::neutron::db
  include kickstack::nova::db
  include kickstack::heat::db
  include kickstack::ceilometer::db

  include kickstack::memcached
}
