class kickstack::neutron::agent::l2 inherits kickstack {
  include kickstack::neutron::config

  case $neutron_plugin {
    'ovs': {
      case $neutron_tenant_network_type {
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
          if $neutron_network_type == 'single-flat' {
            $bridge_uplinks += ["${external_bridge}:${nic_external}"]
          } else {
            $bridge_uplinks = ["br-${nic_data}:${nic_data}"]
          }
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
