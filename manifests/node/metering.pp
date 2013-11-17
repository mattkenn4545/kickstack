class kickstack::node::metering inherits kickstack {
  $keystone_internal_address    = getvar("${fact_prefix}keystone_internal_address")
  $ceilometer_sql_conn          = getvar("${fact_prefix}ceilometer_sql_connection")
  $ceilometer_keystone_password = getvar("${fact_prefix}ceilometer_keystone_password")
  $ceilometer_metering_secret   = getvar("${fact_prefix}ceilometer_metering_secret")

  case $rpc {
    'rabbitmq': {
      $amqp_host      = getvar("${fact_prefix}rabbit_host")
      $amqp_password  = getvar("${fact_prefix}rabbit_password")
    }

    'qpid': {
      $amqp_host      = getvar("${fact_prefix}qpid_host")
      $amqp_password  = getvar("${fact_prefix}qpid_password")
    }
  }

  if $ceilometer_sql_conn and $ceilometer_keystone_password and $ceilometer_metering_secret {
    include kickstack::ceilometer::agent::metering
  }
}
