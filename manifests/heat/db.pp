class kickstack::heat::db (
  $password = 'heat_dbpass'
) inherits kickstack::heat {
  include kickstack::database

  if (defined(Class['kickstack::database::install'])) {
    kickstack::db { 'heat':
      password => $password
    }
  }

  $sql_connection = template("${module_name}/sql_connection.erb")
}
