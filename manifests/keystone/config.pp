class kickstack::keystone::config inherits kickstack::keystone {
  if (!$db_host) {
    $unset_parameter = 'db_host'
  }

  if $unset_parameter {
    $message = inline_template($unset_parameter_template)
    notify { $message: }
  } else {
    include kickstack::keystone::db

    $sql_connection     = $kickstack::keystone::db::sql_connection

    if ($memcached_hosts == [] or true == true) { #Not doing memcached atm due to performance and first run issues
      $token_driver = 'keystone.token.backends.sql.Token'
      $memcache_servers = false
    } else {
      $token_driver = 'keystone.token.backends.memcache.Token'
      $memcache_servers = suffix($memcached_hosts, ':11211')
    }

    class { '::keystone':
      package_ensure    => $package_version,
      verbose           => $verbose,
      debug             => $debug,
      catalog_type      => 'sql',
      admin_token       => $admin_token,
      sql_connection    => $sql_connection,
      token_provider    => $token_provider,
      token_driver      => $token_driver,
      memcache_servers  => $memcache_servers
    }

    kickstack::endpoint { 'keystone': }

    # Adds the admin credential to keystone.
    if defined('::keystone::endpoint') {
      class { '::keystone::roles::admin':
        email             => $admin_email,
        password          => $admin_password,
        admin_tenant      => $admin_tenant,
        service_tenant    => $service_tenant
      }
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
