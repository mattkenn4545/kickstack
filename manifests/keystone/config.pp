class kickstack::keystone::config inherits kickstack::keystone {
  if (!$db_host) {
    $missing_fact = 'db_host'
  }

  if $missing_fact {
    $class = $exported_fact_provider[$missing_fact]

    $message = inline_template($missing_fact_template)
    notify { $message: }
  } else {
    include kickstack::keystone::db

    $sql_connection     = $kickstack::keystone::db::sql_connection

    class { '::keystone':
      package_ensure    => $package_version,
      verbose           => $verbose,
      debug             => $debug,
      catalog_type      => 'sql',
      admin_token       => $admin_token,
      sql_connection    => $sql_connection,
      token_provider    => $token_provider
    }

    kickstack::endpoint { 'keystone': }

    # Adds the admin credential to keystone.
    class { '::keystone::roles::admin':
      email             => $admin_email,
      password          => $admin_password,
      admin_tenant      => $admin_tenant,
      service_tenant    => $service_tenant,
      require           => Class[ '::keystone::endpoint' ]
    }

    kickstack::exportfact { 'auth_host':
      require           => Class[ '::keystone::endpoint' ]
    }

    file { '/root/openstackrc':
      owner             => 'root',
      group             => 'root',
      mode              => '0640',
      content           => template('kickstack/openstackrc.erb'),
      require           => [ Class[ '::keystone::roles::admin' ], Class[ '::keystone' ] ]
    }
  }
}
