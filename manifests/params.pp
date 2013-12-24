class kickstack::params (
  $release,
  $package_version,
  $name_resolution,
  $verbose,
  $debug,
  $cinder_backend,
  $cinder_lvm_pv,
  $cinder_lvm_vg,
  $cinder_rbd_pool,
  $cinder_rbd_user,
  $neutron_network_type,
  $neutron_plugin,
  $neutron_physnet,
  $neutron_tenant_network_type,
  $neutron_network_vlan_ranges,
  $neutron_tunnel_id_ranges,
  $neutron_integration_bridge,
  $neutron_tunnel_bridge,
  $neutron_external_bridge,
  $nic_management,
  $nic_data,
  $nic_external,
  $neutron_router_id,
  $neutron_gateway_external_network_id,
  $nova_compute_driver,
  $nova_compute_libvirt_type,
  $xenapi_connection_url,
  $xenapi_connection_username,
  $xenapi_connection_password,
  $horizon_allow_any_hostname,
  $heat_apis,
  $allow_default_passwords,
  $partition
) {
  validate_bool($verbose, $debug, $horizon_allow_any_hostname, $allow_default_passwords)

  $db_host    = getvar("${partition}_db_host")
  $auth_host  = getvar("${partition}_auth_host")
}
