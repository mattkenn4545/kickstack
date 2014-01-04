class kickstack::cinder::volume inherits kickstack::cinder {
  include kickstack::cinder::config

  if (defined(Class['::cinder'])) {
    class { '::cinder::volume':
      package_ensure        => $package_version
    }

    case $backend {
      'iscsi': {
        physical_volume { $lvm_pv:
          ensure            => present
        } ->
        volume_group { $lvm_vg:
          ensure            => present,
          physical_volumes  => $lvm_pv
        } ->
        class { '::cinder::volume::iscsi':
          iscsi_ip_address  => getvar("ipaddress_${nic_data}")
        }
      }

      'rbd': {
        if (!$rbd_secret_uuid) {
          fail('Unable to use \'rbd\' cinder backend. $rbd_secret_uuid not set.')
        }

        class { '::cinder::volume::rbd':
          rbd_pool          => $rbd_pool,
          rbd_user          => $rbd_user,
          rbd_secret_uuid   => $rbd_secret_uuid
        }
      }

      default: {
        fail("Unsupported Cinder backend: ${backend}")
      }
    }
  } else {
    notify { 'Unable to apply ::cinder::volume': }
  }
}
