class kickstack::keystone (
  $region                   = hiera('kickstack::keystone::region',           'kickstack'),

  # The tenant set up so that individual OpenStack services can
  # authenticate with Keystone
  $service_tenant           = hiera('kickstack::keystone::service_tenant',   'services'),

  # The suffix to append to the keystone hostname for publishing
  # the public service endpoint (default: none)
  $public_suffix            = hiera('kickstack::keystone::public_suffix',    undef),

  # The suffix to append to the keystone hostname for publishing
  # the admin service endpoint (default: none)
  $admin_suffix             = hiera('kickstack::keystone::admin_suffix',     undef)
) inherits kickstack::params {
  $service_name = 'keystone'

  include kickstack::keystone::db
}
