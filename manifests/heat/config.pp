class kickstack::heat::config inherits kickstack::heat {
  if (!$db_host) {
    $missing_fact = 'db_host'
  } elsif (!$rpc_host) {
    $missing_fact = 'rpc_host'
  } elsif (!$auth_host) {
    $missing_fact = 'auth_host'
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
    include kickstack::heat::db

    include kickstack::keystone

    $auth_uri       = "http://${auth_host}:5000/v2.0"

    $sql_connection = $kickstack::heat::db::sql_connection

    case $rpc_server {
      'rabbitmq': {
        class { '::heat':
          package_ensure      => $package_version,
          auth_uri            => $auth_uri,
          sql_connection      => $sql_connection,
          rpc_backend         => 'heat.openstack.common.rpc.impl_kombu',
          rabbit_host         => $rpc_host,
          rabbit_password     => $rpc_password,
          rabbit_virtualhost  => $rabbit_virtual_host,
          rabbit_userid       => $rpc_user,
          keystone_host       => $auth_host,
          keystone_tenant     => $kickstack::keystone::service_tenant,
          keystone_user       => 'heat',
          keystone_password   => $service_password,
          verbose             => $verbose,
          debug               => $debug
        }
      }

      'qpid': {
        class { '::heat':
          package_ensure      => $package_version,
          auth_uri            => $auth_uri,
          sql_connection      => $sql_connection,
          rpc_backend         => 'heat.openstack.common.rpc.impl_qpid',
          qpid_hostname       => $rpc_host,
          qpid_password       => $rpc_password,
          qpid_realm          => $qpid_realm,
          qpid_user           => $rpc_user,
          keystone_host       => $auth_host,
          keystone_tenant     => $kickstack::keystone::service_tenant,
          keystone_user       => 'heat',
          keystone_password   => $service_password,
          verbose             => $verbose,
          debug               => $debug
        }
      }
    }
  }
}
