class kickstack::params (
  $release,
  $package_version,
  $name_resolution,
  $verbose,
  $debug,
  $rpc_server,
  $rpc_user,
  $rpc_password,
  $rabbit_virtual_host,
  $qpid_realm,
  $cinder_backend,
  $cinder_lvm_pv,
  $cinder_lvm_vg,
  $cinder_rbd_pool,
  $cinder_rbd_user,
  $nic_management,
  $nic_data,
  $nic_external,
  $nova_compute_driver,
  $nova_compute_libvirt_type,
  $xenapi_connection_url,
  $xenapi_connection_username,
  $xenapi_connection_password,
  $allow_default_passwords,
  $partition
) {
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

  #Nova
  $vncproxy_host        = getvar("${partition}_vncproxy_host")
  $nova_metadata_ip     = getvar("${partition}_nova_metadata_ip")
}
