class kickstack::neutron (
  $service_password        = hiera('kickstack::neutron::service_password',        'neutron_password'),

  # The network type to configure for Neutron.  See
  # http://docs.openstack.org/grizzly/openstack-network/admin/content/use_cases.html
  # Supported:
  # single-flat
  # provider-router
  # per-tenant-router (default)
  $network_type           = hiera('kickstack::neutron::network_type',             'per-tenant-router'),

  # The plugin to use with Neutron.
  # Supported:
  # linuxbridge
  # ovs (default)
  $plugin                 = hiera('kickstack::neutron::plugin',                   'ovs'),

  # The tenant network type to use with the Neutron ovs and linuxbridge plugins
  # Supported: gre (default), flat, vlan
  $tenant_network_type    = hiera('kickstack::neutron::tenant_network_type',      'gre'),

  # The Neutron physical network name to define
  # Ignored if neutron_tenant_network_type=='gre'
  $physnet                = hiera('kickstack::neutron::physnet',                  'physnet1'),

  # The network VLAN ranges to use with the Neutron ovs and
  # linuxbridge plugins (ignored unless neutron_tenant_network_type ==
  # 'vlan')
  $vlan_ranges            = hiera('kickstack::neutron::vlan_ranges',              '2000:3999'),

  # The tunnel ID ranges to use with the Neutron ovs plugin, when in gre mode
  # Ignored unless neutron_tenant_network_type == 'gre'
  $tunnel_id_ranges       = hiera('kickstack::neutron::tunnel_id_ranges',         '1:1000'),

  $metadata_secret        = hiera('kickstack::neutron::metadata_secret',          'metadata_secret'),

  # The Neutron integration bridge
  # Normally doesn't need to be changed
  $integration_bridge     = hiera('kickstack::neutron::integration_bridge',       'br-int'),

  # The Neutron tunnel bridge
  # Irrelevant unless $neutron_tenant_network_type == 'gre')
  # Normally doesn't need to be changed
  $tunnel_bridge          = hiera('kickstack::neutron::tunnel_bridge',            'br-tun'),

  # The Neutron external bridge
  # Normally doesn't need to be changed
  $external_bridge        = hiera('kickstack::neutron::external_bridge',          'br-ex'),

  # The Neutron router uuid
  # Irrelevant unless $neutron_network_type == 'provider_router')
  $router_id              = hiera('kickstack::neutron::router_id',                undef),

  # The Neutron external network uuid
  # Irrelevant unless $neutron_network_type == 'provider_router')
  $external_network_id    = hiera('kickstack::neutron::external_network_id',      undef)
) inherits kickstack {
  $service_name = 'neutron'
}

