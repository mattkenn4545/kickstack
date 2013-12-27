class kickstack::neutron::plugin inherits kickstack::neutron {
  include kickstack::neutron::config
  include kickstack::neutron::db

  $sql_connection       = $kickstack::neutron::db::sql_connection

  $vlan_ranges          = $tenant_network_type ?  { 'gre'   => '',
                                                    default => "${physnet}:${vlan_ranges}" }
  $tunnel_id_ranges     = $tenant_network_type ?  { 'gre'   => $tunnel_id_ranges,
                                                    default => '' }

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
      if (!defined(Neutron_plugin_ovs[ 'SECURITYGROUP/firewall_driver' ])) {
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
}
