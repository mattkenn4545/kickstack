class kickstack::neutron::db (
  $password = hiera('kickstack::neutron::db::password',  'neutron_pass')
) inherits kickstack::neutron {
  if (defined(Class['kickstack::database'])) {
    kickstack::db { 'neutron':
      password => $password
    }
  }

  $sql_connection = template("${module_name}/sql_connection.erb")
}
