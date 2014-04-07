# Class: kickstack
#
# This module manages kickstack, a thin wrapper around the Stackforge
# Puppet modules that enables easy deployment with any Puppet External
# Node Classifier (ENC), such as Puppet Dashboard, Puppet Enterprise'),
# or The Foreman.

class kickstack (
  $enabled                              = false,
  # The OpenStack release to install
  # * default 'havana'
  # * override by setting to 'folsom' (not recommended) or 'grizzly'
  # This is for new installations only; don't expect this to magically
  # support rolling releases.
  $release                              = 'havana',

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
  $package_version                      = 'installed',

  # The strategy to use so machines can make their hostnames known to
  # each other.
  # * default "hosts" -- manage /etc/hosts
  $name_resolution                      = 'hosts',

  $verbose                              = false,
  $debug                                = false,

  #RPC
  $rpc_server                           = 'rabbitmq',
  $rpc_user                             = 'kickstack',
  $rpc_password                         = 'rpc_pass',
  $rabbit_virtual_host                  = '/',
  $qpid_realm                           = 'OPENSTACK',

  # The interface over which to run your nodes' management network traffic.
  # Normally, this would be your primary network interface.
  $nic_management                       = 'eth0',

  # The interface over which to run your tenant guest traffic.
  # This would be a secondary interface, present on your network node
  # and compute nodes.
  $nic_data                             = 'eth1',

  # The interface you use to connect to the public network.  This
  # interface would only be present on your network nodes, and
  # possibly also on your API nodes if you wish to expose the API
  # services publicly.
  $nic_external                         = 'eth2',

  $allow_default_passwords              = false,

  $kickstack_environment                = pick($kickstack_environment, 'default'),

  #Infrastructure
  $db_host                              = undef,
  $rpc_host                             = undef,

  #Endpoint Hosts
  $haproxy_host                         = undef,

  $ceilometer_api_host                  = undef,
  $nova_api_host                        = undef,
  $cinder_api_host                      = undef,
  $heat_api_host                        = undef,
  $heat_cfn_api_host                    = undef,
  $glance_api_host                      = undef,
  $keystone_api_host                    = undef,
  $neutron_api_host                     = undef,

  #Other Hosts
  $glance_registry_host                 = undef,
  $vncproxy_host                        = undef,

  $nova_metadata_ip                     = undef,

  $memcached_hosts                      = undef
) {
  validate_bool($verbose, $debug, $allow_default_passwords)

  class { 'kickstack::params':
    release                              => $release,
    package_version                      => $package_version,
    name_resolution                      => $name_resolution,
    verbose                              => $verbose,
    debug                                => $debug,
    rpc_server                           => $rpc_server,
    rpc_user                             => $rpc_user,
    rpc_password                         => $rpc_password,
    rabbit_virtual_host                  => $rabbit_virtual_host,
    qpid_realm                           => $qpid_realm,
    nic_management                       => $nic_management,
    nic_data                             => $nic_data,
    nic_external                         => $nic_external,
    allow_default_passwords              => $allow_default_passwords,
    kickstack_environment                => $kickstack_environment,
    db_host                              => $db_host,
    rpc_host                             => $rpc_host,
    haproxy_host                         => $haproxy_host,
    ceilometer_api_host                  => $ceilometer_api_host,
    nova_api_host                        => $nova_api_host,
    cinder_api_host                      => $cinder_api_host,
    heat_api_host                        => $heat_api_host,
    heat_cfn_api_host                    => $heat_cfn_api_host,
    glance_api_host                      => $glance_api_host,
    keystone_api_host                    => $keystone_api_host,
    neutron_api_host                     => $neutron_api_host,
    glance_registry_host                 => $glance_registry_host,
    vncproxy_host                        => $vncproxy_host,
    nova_metadata_ip                     => $nova_metadata_ip,
    memcached_hosts                      => $memcached_hosts
  }

  include kickstack::repo
  include kickstack::nameresolution
}
