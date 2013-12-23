class kickstack::keystone::api inherits kickstack::keystone::params {
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
