class kickstack::nova::config inherits kickstack::nova {
  if (!$db_host) {
    $missing_fact = 'db_host'
  } elsif (!$rpc_host) {
    $missing_fact = 'rpc_host'
  } elsif (!$glance_registry_host) {
    $missing_fact = 'glance_registry_host'
  }

  if $missing_fact {
    $class = $exported_fact_provider[$missing_fact]

    $message = inline_template($missing_fact_template)
    notify { $message: }
  } else {
    include kickstack::nova::db

    $sql_connection             = $kickstack::nova::db::sql_connection

    if ($memcached_hosts == []) {
      $memcache_servers = false
    } else {
      $memcache_servers = suffix($memcached_hosts, ':11211')
    }

    case $rpc_server {
      'rabbitmq': {
        class { '::nova':
          ensure_package      => $package_version,
          sql_connection      => $sql_connection,
          rpc_backend         => 'nova.openstack.common.rpc.impl_kombu',
          rabbit_host         => $rpc_host,
          rabbit_password     => $rpc_password,
          rabbit_virtual_host => $rabbit_virtual_host,
          rabbit_userid       => $rpc_user,
          auth_strategy       => 'keystone',
          verbose             => $verbose,
          debug               => $debug,
          glance_api_servers  => "${glance_registry_host}:9292",
          memcached_servers   => $memcache_servers
        }
      }
      'qpid': {
        class { '::nova':
          ensure_package      => $package_version,
          sql_connection      => $sql_connection,
          rpc_backend         => 'nova.openstack.common.rpc.impl_qpid',
          qpid_hostname       => $rpc_host,
          qpid_password       => $rpc_password,
          qpid_realm          => $qpid_realm,
          qpid_user           => $rpc_user,
          auth_strategy       => 'keystone',
          verbose             => $verbose,
          debug               => $debug,
          glance_api_servers  => "${glance_registry_host}:9292",
          memcached_servers   => $memcache_servers
        }
      }
    }
  }
}
