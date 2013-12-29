class kickstack::nova::compute inherits kickstack::nova {
  include kickstack::nova::config

  $vncserver_listen_address   = getvar("ipaddress_${nic_management}")

  class { '::nova::compute':
    enabled                       => true,
    vnc_enabled                   => true,
    vncserver_proxyclient_address => $vncserver_listen_address,
    vncproxy_host                 => $vncproxy_host,
    virtio_nic                    => true
  }

  case $nova_compute_driver {
    'libvirt': {
      class { '::nova::compute::libvirt':
        libvirt_type      => $libvirt_type,
        vncserver_listen  => $vncserver_listen_address
      }
    }

    'xenserver': {
      class { '::nova::compute::xenserver':
        xenapi_connection_url       => $xenapi_connection_url,
        xenapi_connection_username  => $xenapi_connection_username,
        xenapi_connection_password  => $xenapi_connection_password
      }
    }
  }
}
