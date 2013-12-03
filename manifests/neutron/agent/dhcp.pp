class kickstack::neutron::agent::dhcp inherits kickstack {
  include kickstack::neutron::config

  class { '::neutron::agents::dhcp':
    debug             => $debug,
    interface_driver  => $neutron_plugin ? {
                          'ovs'         => 'neutron.agent.linux.interface.OVSInterfaceDriver',
                          'linuxbridge' => 'neutron.agent.linux.interface.BridgeInterfaceDriver'
                         },
    use_namespaces    => $neutron_network_type ? {
                          'per-tenant-router' => true,
                          default             => false
                         },
    package_ensure    => $package_version
  }
}
