class kickstack::keystone (

) inherits kickstack::params {
  $service_name = 'keystone'

  include kickstack::keystone::db
}
