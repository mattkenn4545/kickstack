class kickstack::glance::db (
  $password = hiera('kickstack::glance::db::password',  'glance_pass')
) inherits kickstack::glance {
  if (defined(Class['kickstack::database'])) {
    kickstack::db { 'glance':
      password => $password
    }
  }

  $sql_connection = template("${module_name}/sql_connection.erb")
}
