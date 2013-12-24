class kickstack::keystone::db (
  $password = hiera('kickstack::keystone::db::password',  'keystone_pass')
) inherits kickstack::keystone {
  if (defined(Class['kickstack::database'])) {
    kickstack::db { 'keystone':
      password => $password
    }
  }

  $sql_connection = template("${module_name}/sql_connection.erb")
}
