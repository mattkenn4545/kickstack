class kickstack::neutron::agent::l3 inherits kickstack::neutron {
  include kickstack::neutron::config

  if (defined(Class['::neutron'])) {
    vs_bridge { $external_bridge:
      ensure => present
    }

    vs_port { $nic_external:
      ensure => present,
      bridge => $external_bridge
    }

    class { '::neutron::agents::l3':
      debug                       => $debug,
      interface_driver            => $plugin ? {
                                            'ovs'               => 'neutron.agent.linux.interface.OVSInterfaceDriver',
                                            'linuxbridge'       => 'neutron.agent.linux.interface.BridgeInterfaceDriver' },
      external_network_bridge     => $external_bridge,
      use_namespaces              => $network_type ? {
                                            'per-tenant-router' => true,
                                            default             => false },
      router_id                   => $network_type ? {
                                            'provider-router'   => $router_id,
                                            default             => undef },
      gateway_external_network_id => $network_type ? {
                                            'provider-router'   => $external_network_id,
                                            default             => undef },
      package_ensure              => $package_version,
      require                     => Vs_bridge[ $external_bridge ]
    }
  } else {
    notify { 'Unable to apply ::neutron::agents::l3': }
  }
}
