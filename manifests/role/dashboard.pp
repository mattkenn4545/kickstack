class kickstack::role::dashboard inherits kickstack {
  include kickstack::horizon::site
  include kickstack::nova::vncproxy
}
