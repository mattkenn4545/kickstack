class kickstack::nova::db (
  $password = 'nova_dbpass'
) inherits kickstack::nova {
  include kickstack::database

  if (defined(Class['kickstack::database::install'])) {
    kickstack::db { 'nova':
      password => $password
    }
  }

  $sql_connection = template("${module_name}/sql_connection.erb")
}
