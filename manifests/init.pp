# Class: kickstack
#
# This module manages kickstack, a thin wrapper around the Stackforge
# Puppet modules that enables easy deployment with any Puppet External
# Node Classifier (ENC), such as Puppet Dashboard, Puppet Enterprise'),
# or The Foreman.

class kickstack (
  # The OpenStack release to install
  # * default 'havana'
  # * override by setting to 'folsom' (not recommended) or 'grizzly'
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

  # Allow access to Horizon using any host name?
  # Default is false, meaning allow Horizon access only through the
  # FQDN of the dashboard host.
  # Set to true if you want to access by IP address, through an SSH
  # tunnel, etc.

  $allow_default_passwords              = hiera('kickstack::allow_default_passwords',             false),

  $partition                            = hiera('kickstack::partition',                           pick($partition, 'default'))
) {
  include ::exportfact

  include kickstack::repo
  include kickstack::nameresolution

  ::exportfact::import { $partition: }

  validate_bool($verbose, $debug, $allow_default_passwords)

  #Infrastructure
  $db_host              = getvar("${partition}_db_host")
  $rpc_host             = getvar("${partition}_rpc_host")

  #Keystone
  $auth_host            = getvar("${partition}_auth_host")

  #Glance
  $glance_registry_host = getvar("${partition}_glance_registry_host")
  $glance_api_host      = getvar("${partition}_glance_api_host")

  #Neutron
  $neutron_host         = getvar("${partition}_neutron_host")

  #Heat
  $heat_metadata_host   = getvar("${partition}_heat_metadata_host")
  $heat_cloudwatch_host = getvar("${partition}_heat_cloudwatch_host")

  #Nova
  $vncproxy_host        = getvar("${partition}_vncproxy_host")
  $nova_metadata_ip     = getvar("${partition}_nova_metadata_ip")

  $missing_fact_template  = "'<%= @missing_fact %>' exported fact missing but provider class '<%= @class %>' is defined.  '<%= @missing_fact %>' should be available next run."
  $missing_fact_fail      = "'<%= @missing_fact %>' exported fact missing. Ensure that '<%= @class %>' is applied for the ${partition} partition."

  $exported_fact_provider = {
    'db_host' => 'kickstack::database::install'
  }
}
