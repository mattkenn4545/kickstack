class kickstack::cinder::db (
  $password = hiera('kickstack::cinder::db::password',  'cinder_pass')
) inherits kickstack::cinder {
  if (defined(Class['kickstack::database'])) {
    kickstack::db { 'cinder':
      password => $password
    }
  }

  $sql_connection = template("${module_name}/sql_connection.erb")
}
