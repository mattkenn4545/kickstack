class kickstack::rpc inherits kickstack {
  case $rpc_server {
    'rabbitmq': {
      class { '::nova::rabbitmq':
        userid        => $rpc_user,
        password      => $rpc_password,
        virtual_host  => $rabbit_virtual_host
      }
    }

    'qpid': {
      class { '::nova::qpid':
        user          => $rpc_user,
        password      => $rpc_password,
        realm         => $qpid_realm
      }
    }
    default: {
      fail("Unsupported RPC server: ${rpc_server}")
    }
  }

  kickstack::exportfact::export { 'rpc_host':
    value             => $fqdn,
    tag               => 'rpc_host'
  }
}
