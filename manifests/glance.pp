class kickstack::glance (

) inherits kickstack::params {
  $service_name = 'glance'

  include kickstack::glance::db
}
