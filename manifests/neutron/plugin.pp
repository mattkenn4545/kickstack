class kickstack::neutron::plugin inherits kickstack {
  include kickstack::neutron::config

  $sql_conn             = getvar("${fact_prefix}neutron_sql_connection")
  $tenant_network_type  = $neutron_tenant_network_type
  $network_vlan_ranges  = $tenant_network_type ?  { 'gre'   => '',
                                                    default => "${neutron_physnet}:${neutron_network_vlan_ranges}" }
  $tunnel_id_ranges     = $tenant_network_type ?  { 'gre'   => $neutron_tunnel_id_ranges,
                                                    default => '' }

  case $neutron_plugin {
    'ovs': {
      class { '::neutron::plugins::ovs':
        sql_connection      => $sql_conn,
        tenant_network_type => $tenant_network_type,
        network_vlan_ranges => $network_vlan_ranges,
        tunnel_id_ranges    => $tunnel_id_ranges,
        package_ensure      => $package_version,
      }
      # This needs to be set for the plugin, not the agent
      # (the latter is what the Neutron module assumes)
#This does not seem to be needed
#      neutron_plugin_ovs { 'SECURITYGROUP/firewall_driver':
#        value     => 'neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver',
#        require   => Class['neutron::plugins::ovs']
#      }
    }
    'linuxbridge': {
      class { '::neutron::plugins::linuxbridge':
        sql_connection      => $sql_conn,
        tenant_network_type => $tenant_network_type,
        network_vlan_ranges => $network_vlan_ranges,
        package_ensure      => $package_version,
      }
    }
  }
}
