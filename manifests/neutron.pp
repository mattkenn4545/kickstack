class kickstack::neutron (

) inherits kickstack::params {
  $service_name = 'neutron'

  include kickstack::neutron::db
}

