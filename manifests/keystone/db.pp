class kickstack::keystone::db (
  $password = hiera('kickstack::keystone::db::password',  'keystone_dbpass')
) inherits kickstack::keystone {
  include kickstack::database

  if (defined(Class['kickstack::database::install'])) {
    kickstack::db { 'keystone':
      password => $password
    }
  }

  $sql_connection = template("${module_name}/sql_connection.erb")
}
