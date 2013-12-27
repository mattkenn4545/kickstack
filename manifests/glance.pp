class kickstack::glance (
  $service_password   = hiera('kickstack::glance::service_password',     'glance_password')
) inherits kickstack::params {
  $service_name = 'glance'
}
