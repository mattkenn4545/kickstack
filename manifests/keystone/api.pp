class kickstack::keystone::api (
  $admin_token              = hiera('kickstack::keystone::api::admin_token',      'admin_token'),
  $admin_password           = hiera('kickstack::keystone::api::admin_password',   'admin_password'),

  # The special tenant set up for administrative purposes
  $admin_tenant             = hiera('kickstack::keystone::api::admin_tenant',     'openstack'),

  $region                   = hiera('kickstack::keystone::api::region',           'kickstack'),

  # The suffix to append to the keystone hostname for publishing
  # the public service endpoint (default: none)
  $public_suffix            = hiera('kickstack::keystone::api::public_suffix',    undef),

  # The suffix to append to the keystone hostname for publishing
  # the admin service endpoint (default: none)
  $admin_suffix             = hiera('kickstack::keystone::api::admin_suffix',     undef),

  # The tenant set up so that individual OpenStack services can
  # authenticate with Keystone
  $service_tenant           = hiera('kickstack::keystone::api::service_tenant',   'services'),

  $admin_email              = hiera('kickstack::keystone::api::admin_email',      "admin@${hostname}")
) inherits kickstack::keystone::params {
  include kickstack::keystone::db

  $sql_connection     = $kickstack::keystone::db::sql_connection

  class { '::keystone':
    package_ensure    => $package_version,
    verbose           => $verbose,
    debug             => $debug,
    catalog_type      => 'sql',
    admin_token       => $admin_token,
    sql_connection    => $sql_connection
  }

  # Installs the service user endpoint.
  class { '::keystone::endpoint':
    public_address    => "${hostname}${public_suffix}",
    admin_address     => "${hostname}${admin_suffix}",
    internal_address  => $hostname,
    region            => $region,
    require           => Class[ '::keystone' ]
  }

  # Adds the admin credential to keystone.
  class { '::keystone::roles::admin':
    email             => $admin_email,
    password          => $admin_password,
    admin_tenant      => $admin_tenant,
    service_tenant    => $service_tenant,
    require           => Class[ '::keystone::endpoint' ]
  }

  file { '/root/openstackrc':
    owner             => 'root',
    group             => 'root',
    mode              => '0640',
    content           => template('kickstack/openstackrc.erb'),
    require           => Class[ '::keystone::roles::admin' ]
  }
}
