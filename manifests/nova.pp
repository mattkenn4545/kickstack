class kickstack::nova (
  $admin_password                   = hiera('kickstack::nova::admin_password',                  'nova_password'),

  # The nova-compute backend driver.
  # Supported: libvirt (default), xenserver
  $compute_driver                   = hiera('kickstack::nova::compute_driver',                  'libvirt'),

  # The hypervisor to use with libvirt
  # Ignored unless nova_compute_driver == libvirt
  # Supported: kvm (default), qemu
  $libvirt_type                     = hiera('kickstack::nova::libvirt_type',                    'kvm'),

  # The XenAPI
  # Ignored unless nova_compute_driver == xenserver
  $xenapi_connection_url            = hiera('kickstack::nova::xenapi_connection_url',           undef),
  $xenapi_connection_username       = hiera('kickstack::nova::xenapi_connection_username',      undef),
  $xenapi_connection_password       = hiera('kickstack::nova::xenapi_connection_password',      undef)
) inherits kickstack::params {
  $service_name = 'nova'
}
