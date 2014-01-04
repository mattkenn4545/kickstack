class kickstack::neutron::db (
  $password = hiera('kickstack::neutron::db::password',  'neutron_dbpass')
) inherits kickstack::neutron {
  include kickstack::database

  if (defined(Class['kickstack::database::install'])) {
    kickstack::db { 'neutron':
      password => $password
    }
  }

  $sql_connection = template("${module_name}/sql_connection.erb")
}
