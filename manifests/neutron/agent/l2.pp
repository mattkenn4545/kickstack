class kickstack::neutron::agent::l2 inherits kickstack::neutron {
  include kickstack::neutron::config

  if (defined(Class['::neutron'])) {
    case $plugin {
      'ovs': {
        if (defined(Class['kickstack::neutron::agent::l3'])) {
          $bridge_mappings = [ "${physnet}:${external_bridge}" ]
          $bridge_uplinks  = [ "${external_bridge}:${nic_external}" ]
        } else {
          $bridge_mappings = []
          $bridge_uplinks  = []
        }

        class { '::neutron::agents::ovs':
          bridge_mappings     => $bridge_mappings,
          bridge_uplinks      => $bridge_uplinks,
          integration_bridge  => $integration_bridge,
          enable_tunneling    => $tenant_network_type ? {
                                      'gre'     => true,
                                      default   => false },
          local_ip            => $tenant_network_type ? {
                                      'gre'     => getvar("ipaddress_${nic_data}"),
                                      default   => '' },
          tunnel_bridge       => $tunnel_bridge,
          package_ensure      => $package_version
        }
      }

      'linuxbridge': {
        class { '::neutron::agents::linuxbridge':
          physical_interface_mappings => "default:${nic_external}",
          package_ensure              => $package_version
        }
      }
    }
  } else {
    notify { "Unable to apply ::neutron::agents::${$plugin}": }
  }
}
