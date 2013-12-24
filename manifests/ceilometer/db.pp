class kickstack::ceilometer::db (
  $password = hiera('kickstack::ceilometer::db::password',  'ceilometer_pass')
) inherits kickstack::ceilometer {
  if (defined(Class['kickstack::database'])) {
    kickstack::db { 'ceilometer':
      password => $password
    }
  }

  $sql_connection = template("${module_name}/sql_connection.erb")
}
