class kickstack::ceilometer::config inherits kickstack {
  $admin_password   = getvar("${fact_prefix}ceilometer_keystone_password")
  $sql_conn         = getvar("${fact_prefix}ceilometer_sql_connection")

  $existing_secret  = getvar("${fact_prefix}ceilometer_metering_secret")

  if $existing_secret {
    $metering_secret = $existing_secret
  } else {
    $metering_secret = pwgen()
    kickstack::exportfact::export { 'ceilometer_metering_secret':
      value => $metering_secret,
      tag => 'ceilometer'
    }
  }

  case $rpc {
    'rabbitmq': {
      $rabbit_host      = getvar("${fact_prefix}rabbit_host")
      $rabbit_password  = getvar("${fact_prefix}rabbit_password")
      class { '::ceilometer':
        package_ensure      => $package_version,
        metering_secret     => $metering_secret,
        rpc_backend         => 'ceilometer.openstack.common.rpc.impl_kombu',
        rabbit_host         => $rabbit_host,
        rabbit_password     => $rabbit_password,
        rabbit_virtualhost  => $rabbit_virtual_host,
        rabbit_userid       => $rabbit_userid,
        verbose             => $verbose,
        debug               => $debug
      }
    }

    'qpid': {
      $qpid_hostname = getvar("${fact_prefix}qpid_hostname")
      $qpid_password = getvar("${fact_prefix}qpid_password")
      class { '::ceilometer':
        package_ensure      => $package_version,
        metering_secret     => $metering_secret,
        rpc_backend         => 'ceilometer.openstack.common.rpc.impl_qpid',
        qpid_hostname       => $qpid_hostname,
        qpid_password       => $qpid_password,
        qpid_realm          => $qpid_realm,
        qpid_user           => $qpid_user,
        verbose             => $verbose,
        debug               => $debug
      }
    }
  } 
}
