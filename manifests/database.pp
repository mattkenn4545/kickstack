class kickstack::database (
  $server           = hiera('kickstack::database::server',          'mysql'),
  $root_password    = hiera('kickstack::database::root_password',   'kickstack')
) inherits kickstack {

}
