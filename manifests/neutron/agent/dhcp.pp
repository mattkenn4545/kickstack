class kickstack::neutron::agent::dhcp inherits kickstack::neutron {
  include kickstack::neutron::config

  class { '::neutron::agents::dhcp':
    debug             => $debug,
    interface_driver  => $plugin ? {
                          'ovs'         => 'neutron.agent.linux.interface.OVSInterfaceDriver',
                          'linuxbridge' => 'neutron.agent.linux.interface.BridgeInterfaceDriver'
                         },
    use_namespaces    => $network_type ? {
                          'per-tenant-router' => true,
                          default             => false
                         },
    package_ensure    => $package_version
  }
}
