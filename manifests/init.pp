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

  $allow_default_passwords              = hiera('kickstack::allow_default_passwords',             false),

  $kickstack_environment                = hiera('kickstack::kickstack_environment',               pick($kickstack_environment, 'default')),

  #Infrastructure
  $db_host                              = undef,
  $rpc_host                             = undef,

  #Keystone
  $auth_host                            = undef,

  #Glance
  $glance_registry_host                 = undef,
  $glance_api_host                      = undef,

  #Neutron
  $neutron_host                         = undef,

  #Heat
  $heat_metadata_host                   = undef,
  $heat_cloudwatch_host                 = undef,

  #Nova
  $vncproxy_host                        = undef,
  $nova_metadata_ip                     = undef
) {
  include ::exportfact

  ::exportfact::import { $kickstack_environment: }

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
    auth_host                            => $auth_host,
    glance_registry_host                 => $glance_registry_host,
    glance_api_host                      => $glance_api_host,
    neutron_host                         => $neutron_host,
    heat_metadata_host                   => $heat_metadata_host,
    heat_cloudwatch_host                 => $heat_cloudwatch_host,
    vncproxy_host                        => $vncproxy_host,
    nova_metadata_ip                     => $nova_metadata_ip
  }

  include kickstack::repo
  include kickstack::nameresolution

  if ($rpc_password == 'rpc_pass') {
    $base_message = 'Default rpc password'
    if ($allow_default_passwords) {
      warning("${base_message}.")
    } else {
      fail("${base_message} and default passwords are not allowed.")
    }
  }
}
