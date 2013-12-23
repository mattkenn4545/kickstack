class kickstack::rpc (
  $server                 = hiera('kickstack::rpc::server',                 'rabbitmq'),

  $userid                 = hiera('kickstack::rpc::userid',                 'kickstack'),
  $password               = hiera('kickstack::rpc::password',               'rpc_pass'),

  $rabbit_virtual_host    = hiera('kickstack::rpc::rabbit_virtual_host',    '/'),
  $qpid_realm             = hiera('kickstack::rpc::qpid_realm',             'OPENSTACK')

) inherits kickstack::params {
  #TODO Warn if password is default

  case $server {
    'rabbitmq': {
      class { '::nova::rabbitmq':
        userid        => $userid,
        password      => $password,
        virtual_host  => $rabbit_virtual_host
      }
    }

    'qpid': {
      class { '::nova::qpid':
        user          => $userid,
        password      => $password,
        realm         => $qpid_realm
      }
    }
    default: {
      warn("Unsupported RPC server type: ${server}")
    }
  }
}
