class kickstack::neutron::agent::l3 inherits kickstack {
  include kickstack::neutron::config

  $external_bridge = $neutron_external_bridge

  vs_bridge { $external_bridge:
    ensure => present
  }

  vs_port { $nic_external:
    ensure => present,
    bridge => $external_bridge
  }

  class { '::neutron::agents::l3':
    debug                       => $debug,
    interface_driver            => $neutron_plugin ? {
                                          'ovs'               => 'neutron.agent.linux.interface.OVSInterfaceDriver',
                                          'linuxbridge'       => 'neutron.agent.linux.interface.BridgeInterfaceDriver' },
    external_network_bridge     => $neutron_external_bridge,
    use_namespaces              => $neutron_network_type ? {
                                          'per-tenant-router' => true,
                                          default             => false },
    router_id                   => $neutron_network_type ? {
                                          'provider-router'   => $neutron_router_id,
                                          default             => undef },
    gateway_external_network_id => $neutron_network_type ? {
                                          'provider-router'   => $neutron_gateway_external_network_id,
                                          default             => undef },
    package_ensure    => $package_version,
    require           => Vs_bridge[$external_bridge],
  }
}
