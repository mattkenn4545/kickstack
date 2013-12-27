class kickstack::ceilometer::config inherits kickstack::ceilometer {
  case $rpc_server {
    'rabbitmq': {
      class { '::ceilometer':
        package_ensure      => $package_version,
        metering_secret     => $metering_secret,
        rpc_backend         => 'ceilometer.openstack.common.rpc.impl_kombu',
        rabbit_host         => $rpc_host,
        rabbit_password     => $rpc_password,
        rabbit_virtual_host => $rabbit_virtual_host,
        rabbit_userid       => $rpc_user,
        verbose             => $verbose,
        debug               => $debug
      }
    }

    'qpid': {
      class { '::ceilometer':
        package_ensure      => $package_version,
        metering_secret     => $metering_secret,
        rpc_backend         => 'ceilometer.openstack.common.rpc.impl_qpid',
        qpid_hostname       => $rpc_host,
        qpid_password       => $rpc_password,
        qpid_realm          => $qpid_realm,
        qpid_user           => $rpc_user,
        verbose             => $verbose,
        debug               => $debug
      }
    }
  }
}
