class kickstack::glance::db (
  $password = 'glance_dbpass'
) inherits kickstack::glance {
  include kickstack::database

  if (defined(Class['kickstack::database::install'])) {
    kickstack::db { 'glance':
      password => $password
    }
  }

  $sql_connection = template("${module_name}/sql_connection.erb")
}
