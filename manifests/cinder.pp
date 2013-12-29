class kickstack::cinder (
  $service_password   = hiera('kickstack::cinder::service_password',     'cinder_password')
) inherits kickstack {
  $service_name = 'cinder'
}
