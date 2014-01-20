class kickstack::keystone (
  $region                   = hiera('kickstack::keystone::region',                'kickstack'),

  $admin_token              = hiera('kickstack::keystone::admin_token',           'admin_token'),
  $admin_password           = hiera('kickstack::keystone::admin_password',        'admin_password'),

  # The special tenant set up for administrative purposes
  $admin_tenant             = hiera('kickstack::keystone::admin_tenant',          'openstack'),

  $admin_email              = hiera('kickstack::keystone::admin_email',           "admin@${hostname}"),

  # The tenant set up so that individual OpenStack services can
  # authenticate with Keystone
  $service_tenant           = hiera('kickstack::keystone::service_tenant',        'services'),

  # The suffix to append to the keystone hostname for publishing
  # the public service endpoint (default: none)
  $public_suffix            = hiera('kickstack::keystone::public_suffix',         undef),

  # The suffix to append to the keystone hostname for publishing
  # the admin service endpoint (default: none)
  $admin_suffix             = hiera('kickstack::keystone::admin_suffix',          undef)
) inherits kickstack {
  $service_name = 'keystone'

  if ($admin_password == 'admin_password' or $admin_token == 'admin_token') {
    if ($kickstack::allow_default_passwords) {
      warning(inline_template($kickstack::default_password_template))
    } else {
      fail(inline_template($kickstack::default_password_template))
    }
  }
}
