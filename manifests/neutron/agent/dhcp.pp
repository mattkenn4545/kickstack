class kickstack::neutron::agent::dhcp inherits kickstack::neutron {
  include kickstack::neutron::config

  if (defined(Class['::neutron'])) {
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
  } else {
    notify { 'Unable to apply ::neutron::agents::dhcp': }
  }
}
