class kickstack::role::dashboard inherits kickstack {
    include kickstack::horizon
    include kickstack::nova::vncproxy
}
