class kickstack::neutron::agent::l2 inherits kickstack::neutron {
  include kickstack::neutron::config

  if (defined(Class['::neutron'])) {
    vs_bridge { $external_bridge:
      ensure => present
    }

    case $plugin {
      'ovs': {
        case $tenant_network_type {
          'gre': {
            vs_port { $nic_external:
              ensure => present,
              bridge => $external_bridge
            }

            $local_tunnel_ip = getvar("ipaddress_${nic_data}")

            class { '::neutron::agents::ovs':
              bridge_mappings     => [],
              bridge_uplinks      => [],
              integration_bridge  => $integration_bridge,
              enable_tunneling    => true,
              local_ip            => $local_tunnel_ip,
              tunnel_bridge       => $tunnel_bridge,
              package_ensure      => $package_version
            }
          }

          default: {
            if $network_type == 'single-flat' {
              $bridge_uplinks = [ "br-${nic_data}:${nic_data}",
                                  "${external_bridge}:${nic_external}" ]
            } else {
              $bridge_uplinks = [ "br-${nic_data}:${nic_data}" ]
            }

            class { '::neutron::agents::ovs':
              bridge_mappings     => ["${physnet}:br-${nic_data}"],
              bridge_uplinks      => $bridge_uplinks,
              integration_bridge  => $integration_bridge,
              enable_tunneling    => false,
              local_ip            => '',
              package_ensure      => $package_version
            }
          }
        }
      }

      'linuxbridge': {
        class { '::neutron::agents::linuxbridge':
          physical_interface_mappings => "default:${nic_data}",
          package_ensure              => $package_version
        }
      }
    }
  } else {
    notify { "Unable to apply ::neutron::agents::${$plugin}": }
  }
}
