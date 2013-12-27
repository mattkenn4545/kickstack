class kickstack::glance::registry inherits kickstack::glance {
  include kickstack::glance::config

  include kickstack::glance::db

  include kickstack::keystone

  $sql_connection             = $kickstack::glance::db::sql_connection

  class { '::glance::registry':
    verbose           => $verbose,
    debug             => $debug,
    auth_host         => $auth_host,
    keystone_tenant   => $kickstack::keystone::service_tenant,
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
