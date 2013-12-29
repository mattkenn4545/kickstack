class kickstack::role::metering inherits kickstack {
  include kickstack::ceilometer::agent::metering
}
