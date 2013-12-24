class kickstack::cinder (

) inherits kickstack::params {
  $service_name = 'cinder'

  include kickstack::cinder::db
}
