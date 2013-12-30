class kickstack::nova::compute inherits kickstack::nova {
  if (!$vncproxy_host) {
    $missing_fact = 'vncproxy_host'
  }

  if $missing_fact {
    $class = $exported_fact_provider[$missing_fact]

    if (defined(Class[$class])) {
      $message = inline_template($missing_fact_warn)
      notify { $message: }
    } else {
      $message = inline_template($missing_fact_fail)
      fail($message)
    }
  } else {
    include kickstack::nova::config

    if (defined(Class['::nova'])) {
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
    } else {
      notify { 'Unable to apply ::nova::compute': }
    }
  }
}
