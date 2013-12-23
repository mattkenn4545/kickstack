class kickstack::nova::db (
  $password = hiera('kickstack::nova::db::password',  'nova_pass')
) inherits kickstack::nova::params {
  kickstack::db { 'nova':
    password => $password
  }

  $sql_connection = template("${module_name}/sql_connection.erb")
}
