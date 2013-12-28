class kickstack::role::infrastructure inherits kickstack::params {
  include kickstack::rpc
  include kickstack::database

  include kickstack::keystone::db
  include kickstack::glance::db
  include kickstack::cinder::db
  include kickstack::neutron::db
  include kickstack::nova::db

  include kickstack::heat::db

  include kickstack::ceilometer::db
}
