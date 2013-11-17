class kickstack::nova::config inherits kickstack {

  $sql_conn           = getvar("${fact_prefix}nova_sql_connection")
  $glance_api_servers = getvar("${fact_prefix}glance_api_host")

  case $rpc {
    'rabbitmq': {
      $rabbit_host      = getvar("${fact_prefix}rabbit_host")
      $rabbit_password  = getvar("${fact_prefix}rabbit_password")
      class { '::nova':
        ensure_package      => $package_version,
        sql_connection      => $sql_conn,
        rpc_backend         => 'nova.openstack.common.rpc.impl_kombu',
        rabbit_host         => $rabbit_host,
        rabbit_password     => $rabbit_password,
        rabbit_virtual_host => $rabbit_virtual_host,
        rabbit_userid       => $rabbit_userid,
        auth_strategy       => 'keystone',
        verbose             => $verbose,
        debug               => $debug,
        glance_api_servers  => "${glance_api_servers}:9292"
      }
    }
    'qpid': {
      $qpid_hostname  = getvar("${fact_prefix}qpid_hostname")
      $qpid_password  = getvar("${fact_prefix}qpid_password")
      class { '::nova':
        ensure_package      => $package_version,
        sql_connection      => $sql_conn,
        rpc_backend         => 'nova.openstack.common.rpc.impl_qpid',
        qpid_hostname       => $qpid_hostname,
        qpid_password       => $qpid_password,
        qpid_realm          => $qpid_realm,
        qpid_user           => $qpid_user,
        auth_strategy       => 'keystone',
        verbose             => $verbose,
        debug               => $debug,
        glance_api_servers  => "${glance_api_servers}:9292"
      }
    }
  } 
}
