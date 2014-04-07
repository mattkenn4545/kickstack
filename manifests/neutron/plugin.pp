class kickstack::neutron::plugin inherits kickstack::neutron {
  if (!$db_host) {
    $unset_parameter = 'db_host'
  }

  if $unset_parameter {
    $message = inline_template($unset_parameter_template)
    notify { $message: }
  } else {
    include kickstack::neutron::config

    if (defined(Class['::neutron'])) {
      include kickstack::neutron::db

      $sql_connection       = $kickstack::neutron::db::sql_connection

      $vlan_ranges          = $tenant_network_type ?  { 'gre'   => '',
                                                        default => "${physnet}:${vlan_ranges}" }
      $tunnel_id_ranges     = $tenant_network_type ?  { 'gre'   => $tunnel_id_ranges,
                                                        default => '' }
      $tenant_network_type  = $tenant_network_type ? { 'flat'   => 'vlan',
                                                        default => $tenant_network_type }

      case $plugin {
        'ovs': {
          class { '::neutron::plugins::ovs':
            sql_connection      => $sql_connection,
            tenant_network_type => $tenant_network_type,
            network_vlan_ranges => $vlan_ranges,
            tunnel_id_ranges    => $tunnel_id_ranges,
            package_ensure      => $package_version
          }
          # This needs to be set for the plugin, not the agent
          # (the latter is what the Neutron module assumes)
          if (!defined(Class['kickstack::neutron::agent::l2'])) {
            neutron_plugin_ovs { 'SECURITYGROUP/firewall_driver':
              value             => 'neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver',
              require           => Class['neutron::plugins::ovs']
            }
          }
        }
        'linuxbridge': {
          class { '::neutron::plugins::linuxbridge':
            sql_connection      => $sql_connection,
            tenant_network_type => $tenant_network_type,
            network_vlan_ranges => $vlan_ranges,
            package_ensure      => $package_version
          }
        }
      }
    } else {
      notify { "Unable to apply ::neutron::plugins::${$plugin}": }
    }
  }
}
