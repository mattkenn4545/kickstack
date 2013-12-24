class kickstack::keystone (
  $admin_token              = hiera('kickstack::keystone::admin_token',      'admin_token'),
  $admin_password           = hiera('kickstack::keystone::admin_password',   'admin_password'),

  # The special tenant set up for administrative purposes
  $admin_tenant             = hiera('kickstack::keystone::admin_tenant',     'openstack'),

  $region                   = hiera('kickstack::keystone::region',           'kickstack'),

  # The suffix to append to the keystone hostname for publishing
  # the public service endpoint (default: none)
  $public_suffix            = hiera('kickstack::keystone::public_suffix',    undef),

  # The suffix to append to the keystone hostname for publishing
  # the admin service endpoint (default: none)
  $admin_suffix             = hiera('kickstack::keystone::admin_suffix',     undef),

  # The tenant set up so that individual OpenStack services can
  # authenticate with Keystone
  $service_tenant           = hiera('kickstack::keystone::service_tenant',   'services'),

  $admin_email              = hiera('kickstack::keystone::admin_email',      "admin@${hostname}")
) inherits kickstack::params {
  $service_name = 'keystone'
}
