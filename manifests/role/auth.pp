class kickstack::role::auth inherits kickstack {
  include kickstack::keystone
  include kickstack::keystone::api
}
