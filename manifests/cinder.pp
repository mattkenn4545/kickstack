class kickstack::cinder (
  $service_password   = 'cinder_password',

  $backend            = 'iscsi',

  # The device to create the LVM physical volume on.
  # Ignored unless $backend == iscsi.
  $lvm_pv             = '/dev/disk/by-partlabel/cinder-volumes',

  # The LVM volume group name to use for volumes.
  # Ignored unless $backend == iscsi.
  $lvm_vg             = 'cinder-volumes',

  # The RADOS pool to use for volumes.
  # Ignored unless $backend == rbd.
  $rbd_pool           = 'cinder-volumes',

  # The RADOS user to use for volumes.
  # Ignored unless $backend == rbd.
  $rbd_user           = 'cinder',

  $rbd_secret_uuid    = undef
) inherits kickstack::params {
  $service_name = 'cinder'

  if ($service_password == "${service_name}_password") {
    if ($allow_default_passwords) {
      warning(inline_template($default_password_template))
    } else {
      fail(inline_template($default_password_template))
    }
  }
}
