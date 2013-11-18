class kickstack::rpc inherits kickstack {
  case $rpc {
    'rabbitmq': {
      Class['::nova::rabbitmq'] -> Exportfact::Export<| tag == 'rabbit' |>

      $rabbit_password = pick(getvar("${fact_prefix}rabbit_password"), pwgen())

      class { '::nova::rabbitmq':
        userid        => $rabbit_userid,
        password      => $rabbit_password,
        virtual_host  => $rabbit_virtual_host
      }

      kickstack::exportfact::export { 'rabbit_host':
        value         => $hostname,
        tag           => 'rabbit'
      }

      kickstack::exportfact::export { 'rabbit_password':
        value         => $rabbit_password,
        tag           => 'rabbit'
      }

    }

    'qpid': {
      Class['::nova::qpid'] -> Exportfact::Export<| tag == 'qpid' |>

      $qpid_password = pick(getvar("${fact_prefix}qpid_password"),pwgen())

      class { '::nova::qpid':
        user          => $qpid_username,
        password      => $qpid_password,
        realm         => $qpid_realm
      }

      kickstack::exportfact::export { 'qpid_hostname':
        value         => $hostname,
        tag           => 'qpid'
      }

      kickstack::exportfact::export { 'qpid_password':
        value         => $qpid_password,
        tag           => 'qpid'
      }
    }
    default: {
      warn("Unsupported RPC server type: ${rpc}")
    }
  }
}
