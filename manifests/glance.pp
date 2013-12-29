class kickstack::glance (
  $service_password   = hiera('kickstack::glance::service_password',     'glance_password')
) inherits kickstack {
  $service_name = 'glance'
}
