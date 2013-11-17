class kickstack::neutron::agent::l2::compute inherits kickstack {
  include kickstack::neutron::config

  $tenant_network_type = $tenant_network_type

  case $neutron_plugin {
    'ovs': {
      case $tenant_network_type {
        'gre': {
          $local_tunnel_ip = getvar("ipaddress_${nic_data}")
          class { '::neutron::agents::ovs':
            bridge_mappings     => [],
            bridge_uplinks      => [],
            integration_bridge  => $neutron_integration_bridge,
            enable_tunneling    => true,
            local_ip            => $local_tunnel_ip,
            tunnel_bridge       => $neutron_tunnel_bridge,
            package_ensure      => $package_version,
          }
        }
        default: {
          $bridge_uplinks = ["br-${nic_data}:${nic_data}"]
          class { '::neutron::agents::ovs':
            bridge_mappings     => ["${neutron_physnet}:br-${nic_data}"],
            bridge_uplinks      => $bridge_uplinks,
            integration_bridge  => $neutron_integration_bridge,
            enable_tunneling    => false,
            local_ip            => '',
            package_ensure      => $package_version,
          }
        }
      }
    }
    'linuxbridge': {
      class { '::neutron::agents::linuxbridge':
        physical_interface_mappings => "default:${nic_data}",
        package_ensure              => $package_version,
      }
    }
  } 
}
