class kickstack::glance::api inherits kickstack::glance {
  include kickstack::glance::config

  include kickstack::glance::db

  include kickstack::keystone

  $sql_connection             = $kickstack::glance::db::sql_connection

  class { '::glance::api':
    verbose           => $verbose,
    debug             => $debug,
    auth_type         => 'keystone',
    auth_host         => $auth_host,
    keystone_tenant   => $kickstack::keystone::service_tenant,
    keystone_user     => 'glance',
    keystone_password => $service_password,
    sql_connection    => $sql_connection,
    registry_host     => $glance_registry_host
  }

  kickstack::endpoint { 'glance':
    service_password  => $service_password,
    require           => Class['::glance::api']
  }

  kickstack::exportfact::export { 'glance_api_host':
    value             => $fqdn,
    tag               => 'glance',
    require           => Class['::glance::api']
  }
}
