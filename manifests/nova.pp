class kickstack::nova (

) inherits kickstack::params {
  $service_name = 'nova'

  include kickstack::nova::db
}

