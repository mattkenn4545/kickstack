class kickstack::ceilometer::db (
  $password = hiera('kickstack::ceilometer::db::password',  'ceilometer_pass')
) inherits kickstack::ceilometer {
  include kickstack::database

  if (defined(Class['kickstack::database::install'])) {
    kickstack::db { 'ceilometer':
      password => $password
    }
  }

  $sql_connection = template("${module_name}/sql_connection.erb")
}
