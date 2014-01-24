class kickstack::database::install inherits kickstack::database {
  case $server {
    'mysql': {
      ensure_resource('class',
                      'mysql::server',
                      { config_hash => {
                        'root_password' => $root_password,
                        'bind_address'  => '0.0.0.0'
                        }
                      })
      ensure_resource('file',
                      '/etc/mysql/conf.d/skip-name-resolve.cnf',
                      { source => 'puppet:///modules/kickstack/mysql/skip-name-resolve.cnf',
                      })
    }

    'postgresql': {
      ensure_resource('class',
                      'postgresql::server',
                      { config_hash => {
                        'ip_mask_deny_postgres_user'  => '0.0.0.0/32',
                        'ip_mask_allow_all_users'     => '0.0.0.0/0',
                        'listen_addresses'            => '*',
                        'postgres_password'           => $root_password
                        }
                      })
    }

    default: {
      fail("Unsupported kickstack::database::server: ${server}")
    }
  }

  kickstack::exportfact { 'db_host': }
}
