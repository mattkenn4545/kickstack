class kickstack::heat (

) inherits kickstack::params {
  $service_name = 'heat'

  include kickstack::heat::db
}
