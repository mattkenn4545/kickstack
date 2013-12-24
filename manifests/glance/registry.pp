class kickstack::glance::registry (
  $service_password   = hiera('kickstack::glance::registry::service_password',     'glance_password')

) inherits kickstack::glance {
  include kickstack::glance::config

  $sql_connection             = $kickstack::glance::db::sql_connection

  class { '::glance::registry':
    verbose           => $verbose,
    debug             => $debug,
    auth_host         => $auth_host,
    keystone_tenant   => $service_tenant,
    keystone_user     => 'glance',
    keystone_password => $service_password,
    sql_connection    => $sql_connection
  }

  # Export the registry host name string for the service
  kickstack::exportfact::export { 'glance_registry_host':
    value             => $fqdn,
    tag               => 'glance',
    require           => Class[ '::glance::registry' ]
  }
}
