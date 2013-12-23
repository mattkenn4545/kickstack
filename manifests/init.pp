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
  $release                              = hiera('kickstack::release',                             'grizzly'),

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
  $database                             = hiera('kickstack::database',                            'mysql'),

  # The mysql "root" user's password
  # (ignored unless database=='mysql')
  $mysql_root_password                  = hiera('kickstack::mysql_root_password',                 'kickstack'),

  # The "postgres" user's password
  # (ignored unless kickstack_database=='postgresql')
  $postgres_password                    = hiera('kickstack::postgres_password',                   'kickstack'),

  $rpc                                  = hiera('kickstack::rpc',                                 'rabbitmq'),
  $rabbit_userid                        = hiera('kickstack::rabbit_userid',                       'kickstack'),
  $rabbit_virtual_host                  = hiera('kickstack::rabbit_virtual_host',                 '/'),
  $qpid_username                        = hiera('kickstack::qpid_username',                       'kickstack'),
  $qpid_realm                           = hiera('kickstack::qpid_realm',                          undef),
  $keystone_region                      = hiera('kickstack::keystone_region',                     'kickstack'),

  # The suffix to append to the keystone hostname for publishing
  # the public service endpoint (default: none)
  $keystone_public_suffix               = hiera('kickstack::keystone_public_suffix',              undef),

  # The suffix to append to the keystone hostname for publishing
  # the admin service endpoint (default: none)
  $keystone_admin_suffix                = hiera('kickstack::keystone_admin_suffix',               undef),

  # The special tenant set up for administrative purposes
  $keystone_admin_tenant                = hiera('kickstack::keystone_admin_tenant',               'openstack'),

  # The tenant set up so that individual OpenStack services can
  # authenticate with Keystone
  $keystone_service_tenant              = hiera('kickstack::keystone_service_tenant',             'services'),

  $keystone_admin_email                 = hiera('kickstack::keystone_admin_email',                "admin@${hostname}"),
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

  # The network type to configure for Neutron.  See
  # http://docs.openstack.org/grizzly/openstack-network/admin/content/use_cases.html
  # Supported:
  # single-flat
  # provider-router
  # per-tenant-router (default)
  $neutron_network_type                 = hiera('kickstack::neutron_network_type', 'per-tenant-router'),

  # The plugin to use with Neutron.
  # Supported:
  # linuxbridge
  # ovs (default)
  $neutron_plugin                       = hiera('kickstack::neutron_plugin',                      'ovs'),

  # The Neutron physical network name to define
  # Ignored if neutron_tenant_network_type=='gre'
  $neutron_physnet                      = hiera('kickstack::neutron_physnet',                     'physnet1'),

  # The tenant network type to use with the Neutron ovs and linuxbridge plugins
  # Supported: gre (default), flat, vlan
  $neutron_tenant_network_type          = hiera('kickstack::neutron_tenant_network_type',         'gre'),

  # The network VLAN ranges to use with the Neutron ovs and
  # linuxbridge plugins (ignored unless neutron_tenant_network_type ==
  # 'vlan')
  $neutron_network_vlan_ranges          = hiera('kickstack::neutron_network_vlan_ranges',         '2000:3999'),

  # The tunnel ID ranges to use with the Neutron ovs plugin, when in gre mode
  # Ignored unless neutron_tenant_network_type == 'gre'
  $neutron_tunnel_id_ranges             = hiera('kickstack::neutron_tunnel_id_ranges',            '1:1000'),

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
  $heat_apis                            = hiera('kickstack::heat_apis', 'heat')
) {
  class { 'kickstack::params':
    release                               => $release,
    package_version                       => $package_version,
    name_resolution                       => $name_resolution,
    verbose                               => $verbose,
    debug                                 => $debug,
    database                              => $database,
    mysql_root_password                   => $mysql_root_password,
    postgres_password                     => $postgres_password,
    rpc                                   => $rpc,
    rabbit_userid                         => $rabbit_userid,
    rabbit_virtual_host                   => $rabbit_virtual_host,
    qpid_username                         => $qpid_username,
    qpid_realm                            => $qpid_realm,
    keystone_region                       => $keystone_region,
    keystone_public_suffix                => $keystone_public_suffix,
    keystone_admin_suffix                 => $keystone_admin_suffix,
    keystone_admin_tenant                 => $keystone_admin_tenant,
    keystone_service_tenant               => $keystone_service_tenant,
    keystone_admin_email                  => $keystone_admin_email,
    cinder_backend                        => $cinder_backend,
    cinder_lvm_pv                         => $cinder_lvm_pv,
    cinder_lvm_vg                         => $cinder_lvm_vg,
    cinder_rbd_pool                       => $cinder_rbd_pool,
    cinder_rbd_user                       => $cinder_rbd_user,
    neutron_network_type                  => $neutron_network_type,
    neutron_plugin                        => $neutron_plugin,
    neutron_physnet                       => $neutron_physnet,
    neutron_tenant_network_type           => $neutron_tenant_network_type,
    neutron_network_vlan_ranges           => $neutron_network_vlan_ranges,
    neutron_tunnel_id_ranges              => $neutron_tunnel_id_ranges,
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
    heat_apis                             => $heat_apis
  }

  include kickstack::repo
  include kickstack::nameresolution
}
