class kickstack::nova::config inherits kickstack::nova {
  if (!$db_host) {
    $unset_parameter = 'db_host'
  } elsif (!$rpc_host) {
    $unset_parameter = 'rpc_host'
  } elsif (!$glance_registry_host) {
    $unset_parameter = 'glance_registry_host'
  }

  if $unset_parameter {
    $message = inline_template($unset_parameter_template)
    notify { $message: }
  } else {
    include kickstack::nova::db

    $sql_connection             = $kickstack::nova::db::sql_connection

    $memcache_servers = false
#    if ($memcached_hosts == []) {
#      $memcache_servers = false
#    } else {
#      $memcache_servers = suffix($memcached_hosts, ':11211')
#    }

    include kickstack::cinder

    if ($kickstack::cinder::backend == 'rbd') {
      class { '::nova::compute::rbd':
        libvirt_rbd_user            => $kickstack::cinder::rbd_user,
        libvirt_rbd_secret_uuid     => $kickstack::cinder::rbd_secret_uuid,
        libvirt_images_rbd_pool     => $kickstack::cinder::rbd_pool
      }
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
