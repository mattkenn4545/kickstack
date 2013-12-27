class kickstack::nova (
  $admin_password        = hiera('kickstack::nova::admin_password',        'nova_password')
) inherits kickstack::params {
  $service_name = 'nova'

  include kickstack::nova::db
}
