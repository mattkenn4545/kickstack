class kickstack::neutron::config inherits kickstack::neutron {
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
    $allow_overlapping_ips = $network_type ? {
      'single-flat'       => false,
      'provider-router'   => false,
      'per-tenant-router' => true
    }

    $core_plugin = $plugin ? {
      'ovs'         => 'neutron.plugins.openvswitch.ovs_neutron_plugin.OVSNeutronPluginV2',
      'linuxbridge' => 'neutron.plugins.linuxbridge.lb_neutron_plugin.LinuxBridgePluginV2'
    }

    case $rpc_server {
      'rabbitmq': {
        class { '::neutron':
          rpc_backend           => 'neutron.openstack.common.rpc.impl_kombu',
          rabbit_host           => $rpc_host,
          rabbit_virtual_host   => $rabbit_virtual_host,
          rabbit_user           => $rpc_user,
          rabbit_password       => $rpc_password,
          verbose               => $verbose,
          debug                 => $debug,
          allow_overlapping_ips => $allow_overlapping_ips,
          core_plugin           => $core_plugin,
        }
      }
      'qpid': {
        class { '::neutron':
          rpc_backend           => 'neutron.openstack.common.rpc.impl_qpid',
          qpid_hostname         => $rpc_host,
          qpid_realm            => $qpid_realm,
          qpid_username         => $rpc_user,
          qpid_password         => $rpc_password,
          verbose               => $verbose,
          debug                 => $debug,
          allow_overlapping_ips => $allow_overlapping_ips,
          core_plugin           => $core_plugin,
        }
      }
    }
  }
}
