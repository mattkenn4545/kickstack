# Class: kickstack
#
# This module manages kickstack, a thin wrapper around the Stackforge
# Puppet modules that enables easy deployment with any Puppet External
# Node Classifier (ENC), such as Puppet Dashboard, Puppet Enterprise'),
# or The Foreman.

class kickstack (
  # The OpenStack release to install
  # * default 'grizzly'
  # * override by setting to 'folsom' (not recommended) or 'havana'
  # This is for new installations only; don't expect this to magically
  # support rolling releases.
  $release                              = hiera('kickstack::release',                             'havana'),

  # Version number of OpenStack *server* packages.
  #
  # * default 'installed', meaning use whatever version is available
  #   at the time of installation, and don't upgrade
  # * set to 'latest' to use whichever is the latest version available
  #   in the package repos, upgrading existing packages if necessary
  # * set to a specific version number if you want to lock your system
  #   to a particular build
  #
  # Note: if you set this to a specific version, then this assumes
  # that your distro synchronizes version numbers across OpenStack
  # server packages.
  $package_version                      = hiera('kickstack::package_version',                     'installed'),

  # The strategy to use so machines can make their hostnames known to
  # each other.
  # * default "hosts" -- manage /etc/hosts
  $name_resolution                      = hiera('kickstack::name_resolution',                     'hosts'),

  $verbose                              = hiera('kickstack::verbose',                             false),
  $debug                                = hiera('kickstack::debug',                               false),

  #RPC
  $rpc_server                           = hiera('kickstack::rpc_server',                          'rabbitmq'),
  $rpc_user                             = hiera('kickstack::rpc_user',                            'kickstack'),
  $rpc_password                         = hiera('kickstack::rpc_password',                        'rpc_pass'),
  $rabbit_virtual_host                  = hiera('kickstack::rabbit_virtual_host',                 '/'),
  $qpid_realm                           = hiera('kickstack::qpid_realm',                          'OPENSTACK'),

  $cinder_backend                       = hiera('kickstack::cinder_backend',                      'iscsi'),

  # The device to create the LVM physical volume on.
  # Ignored unless $cinder_backend == iscsi.
  $cinder_lvm_pv                        = hiera('kickstack::cinder_lvm_pv',                       '/dev/disk/by-partlabel/cinder-volumes'),

  # The LVM volume group name to use for volumes.
  # Ignored unless $cinder_backend == iscsi.
  $cinder_lvm_vg                        = hiera('kickstack::cinder_lvm_vg',                       'cinder-volumes'),

  # The RADOS pool to use for volumes.
  # Ignored unless $cinder_backend == rbd.
  $cinder_rbd_pool                      = hiera('kickstack::cinder_rbd_pool',                     'cinder-volumes'),

  # The RADOS user to use for volumes.
  # Ignored unless $cinder_backend == rbd.
  $cinder_rbd_user                      = hiera('kickstack::cinder_rbd_user',                     'cinder'),

  # The Neutron integration bridge
  # Normally doesn't need to be changed
  $neutron_integration_bridge           = hiera('kickstack::neutron_integration_bridge',          'br-int'),

  # The Neutron tunnel bridge
  # Irrelevant unless $neutron_tenant_network_type == 'gre')
  # Normally doesn't need to be changed
  $neutron_tunnel_bridge                = hiera('kickstack::neutron_tunnel_bridge',               'br-tun'),

  # The Neutron external bridge
  # Normally doesn't need to be changed
  $neutron_external_bridge              = hiera('kickstack::neutron_external_bridge',             'br-ex'),

  # The interface over which to run your nodes' management network traffic.
  # Normally, this would be your primary network interface.
  $nic_management                       = hiera('kickstack::nic_management',                      'eth0'),

  # The interface over which to run your tenant guest traffic.
  # This would be a secondary interface, present on your network node
  # and compute nodes.
  $nic_data                             = hiera('kickstack::nic_data',                            'eth1'),

  # The interface you use to connect to the public network.  This
  # interface would only be present on your network nodes, and
  # possibly also on your API nodes if you wish to expose the API
  # services publicly.
  $nic_external                         = hiera('kickstack::nic_external',                        'eth2'),

  # The Neutron router uuid
  # Irrelevant unless $neutron_network_type == 'provider_router')
  $neutron_router_id                    = hiera('kickstack::neutron_router_id',                   undef),

  # The Neutron external network uuid
  # Irrelevant unless $neutron_network_type == 'provider_router')
  $neutron_gateway_external_network_id  = hiera('kickstack::neutron_gateway_external_network_id', undef),

  # The nova-compute backend driver.
  # Supported: libvirt (default), xenserver
  $nova_compute_driver                  = hiera('kickstack::nova_compute_driver',                 'libvirt'),

  # The hypervisor to use with libvirt
  # Ignored unless nova_compute_driver == libvirt
  # Supported: kvm (default), qemu
  $nova_compute_libvirt_type            = hiera('kickstack::nova_compute_libvirt_type',           'kvm'),

  # The XenAPI
  # Ignored unless nova_compute_driver == xenserver
  $xenapi_connection_url                = hiera('kickstack::xenapi_connection_url',               undef),
  $xenapi_connection_username           = hiera('kickstack::xenapi_connection_username',          undef),
  $xenapi_connection_password           = hiera('kickstack::xenapi_connection_password',          undef),

  # Allow access to Horizon using any host name?
  # Default is false, meaning allow Horizon access only through the
  # FQDN of the dashboard host.
  # Set to true if you want to access by IP address, through an SSH
  # tunnel, etc.
  $horizon_allow_any_hostname           = hiera('kickstack::horizon_allow_any_hostname',          false),

  # Enabled Heat APIs (comma-separated list of exposed APIs)
  # Can be any combination of 'heat', 'cfn', and 'cloudwatch'
  # Default is just (the native Heat API)
  $heat_apis                            = hiera('kickstack::heat_apis',                           'heat'),
  $allow_default_passwords              = hiera('kickstack::allow_default_passwords',             false),

  $partition                            = hiera('kickstack::partition',                           pick($partition, 'default'))
) {
  class { 'kickstack::params':
    release                               => $release,
    package_version                       => $package_version,
    name_resolution                       => $name_resolution,
    verbose                               => $verbose,
    debug                                 => $debug,
    rpc_server                            => $rpc_server,
    rpc_user                              => $rpc_user,
    rpc_password                          => $rpc_password,
    rabbit_virtual_host                   => $rabbit_virtual_host,
    qpid_realm                            => $qpid_realm,
    cinder_backend                        => $cinder_backend,
    cinder_lvm_pv                         => $cinder_lvm_pv,
    cinder_lvm_vg                         => $cinder_lvm_vg,
    cinder_rbd_pool                       => $cinder_rbd_pool,
    cinder_rbd_user                       => $cinder_rbd_user,
    neutron_integration_bridge            => $neutron_integration_bridge,
    neutron_tunnel_bridge                 => $neutron_tunnel_bridge,
    neutron_external_bridge               => $neutron_external_bridge,
    nic_management                        => $nic_management,
    nic_data                              => $nic_data,
    nic_external                          => $nic_external,
    neutron_router_id                     => $neutron_router_id,
    neutron_gateway_external_network_id   => $neutron_gateway_external_network_id,
    nova_compute_driver                   => $nova_compute_driver,
    nova_compute_libvirt_type             => $nova_compute_libvirt_type,
    xenapi_connection_url                 => $xenapi_connection_url,
    xenapi_connection_username            => $xenapi_connection_username,
    xenapi_connection_password            => $xenapi_connection_password,
    horizon_allow_any_hostname            => $horizon_allow_any_hostname,
    heat_apis                             => $heat_apis,
    allow_default_passwords               => $allow_default_passwords,
    partition                             => $partition
  }
  include ::exportfact

  include kickstack::repo
  include kickstack::nameresolution

  ::exportfact::import { $partition: }
}
