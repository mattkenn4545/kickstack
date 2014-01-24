class kickstack::keystone (
  $region                   = 'kickstack',

  $admin_token              = 'admin_token',
  $admin_password           = 'admin_password',

  # The special tenant set up for administrative purposes
  $admin_tenant             = 'openstack',

  $admin_email              = "admin@${fqdn}",

  # The tenant set up so that individual OpenStack services can
  # authenticate with Keystone
  $service_tenant           = 'services',

  # The suffix to append to the keystone hostname for publishing
  # the public service endpoint (default: none)
  $public_suffix            = undef,

  # The suffix to append to the keystone hostname for publishing
  # the admin service endpoint (default: none)
  $admin_suffix             = undef,

  $token_provider           = 'keystone.token.providers.uuid.Provider'
) inherits kickstack::params {
  $service_name = 'keystone'

  if ($admin_password == 'admin_password' or $admin_token == 'admin_token') {
    if ($allow_default_passwords) {
      warning(inline_template($default_password_template))
    } else {
      fail(inline_template($default_password_template))
    }
  }
}
