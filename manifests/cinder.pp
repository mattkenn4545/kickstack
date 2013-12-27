class kickstack::cinder (
  $service_password   = hiera('kickstack::cinder::service_password',     'cinder_password')
) inherits kickstack::params {
  $service_name = 'cinder'
}
