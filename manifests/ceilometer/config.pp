class kickstack::ceilometer::config inherits kickstack::ceilometer {
  if (!$rpc_host) {
    $missing_fact = 'rpc_host'
  }

  if $missing_fact {
    $class = $exported_fact_provider[$missing_fact]

    if (defined(Class[$class])) {
      $message = inline_template($missing_fact_warn)
      notify { $message: }
    } else {
      $message = inline_template($missing_fact_fail)
      fail($message)
    }
  } else {
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
}
