class kickstack::rpc inherits kickstack::params {
  if (!$rpc_host) {
    $unset_parameter = 'rpc_host'
    $is_provided = true
  }

  if $unset_parameter {
    $message = inline_template($unset_parameter_template)
    notify { $message: }
  } else {
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
  }
}
