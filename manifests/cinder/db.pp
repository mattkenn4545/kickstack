class kickstack::cinder::db (
  $password = hiera('kickstack::cinder::db::password',  'cinder_dbpass')
) inherits kickstack::cinder {
  include kickstack::database

  if (defined(Class['kickstack::database::install'])) {
    kickstack::db { 'cinder':
      password => $password
    }
  }

  $sql_connection = template("${module_name}/sql_connection.erb")
}
