class kickstack::cinder::config inherits kickstack::cinder {
  if (!$db_host) {
    $missing_fact = 'db_host'
  } elsif (!$rpc_host) {
    $missing_fact = 'rpc_host'
  }

  if $missing_fact {
    $class = $exported_fact_provider[$missing_fact]

    if (defined(Class[$class])) {
      $message = inline_template($missing_fact_template)
      notify { $message: }
    } else {
      $message = inline_template($missing_fact_fail)
      fail($message)
    }
  } else {
    include kickstack::cinder::db

    $sql_connection             = $kickstack::cinder::db::sql_connection

    case $rpc_server {
      'rabbitmq': {
        class { '::cinder':
          sql_connection      => $sql_connection,
          rpc_backend         => 'cinder.openstack.common.rpc.impl_kombu',
          rabbit_host         => $rpc_host,
          rabbit_virtual_host => $rabbit_virtual_host,
          rabbit_userid       => $rpc_user,
          rabbit_password     => $rpc_password,
          verbose             => $verbose,
          debug               => $debug
        }
      }

      'qpid': {
        class { '::cinder':
          sql_connection      => $sql_connection,
          rpc_backend         => 'cinder.openstack.common.rpc.impl_qpid',
          qpid_hostname       => $rpc_host,
          qpid_realm          => $qpid_realm,
          qpid_username       => $rpc_user,
          qpid_password       => $rpc_password,
          verbose             => $verbose,
          debug               => $debug
        }
      }
    }
  }
}
