class kickstack::params (
  $release,
  $package_version,
  $name_resolution,
  $verbose,
  $debug,
  $rpc_server,
  $rpc_user,
  $rpc_password,
  $rabbit_virtual_host,
  $qpid_realm,
  $nic_management,
  $nic_data,
  $nic_external,
  $allow_default_passwords,
  $kickstack_environment,

  #Infrastructure
  $db_host                      = pick(getvar("${kickstack_environment}_db_host"),                false),
  $rpc_host                     = pick(getvar("${kickstack_environment}_rpc_host"),               false),

  #Endpoint Hosts
  $ceilometer_api_host          = pick(getvar("${kickstack_environment}_ceilometer_api_host"),    false),
  $nova_api_host                = pick(getvar("${kickstack_environment}_nova_api_host"),          false),
  $cinder_api_host              = pick(getvar("${kickstack_environment}_cinder_api_host"),        false),
  $heat_api_host                = pick(getvar("${kickstack_environment}_heat_api_host"),          false),
  $heat_cfn_api_host            = pick(getvar("${kickstack_environment}_heat_cfn_api_host"),      false),
  $glance_api_host              = pick(getvar("${kickstack_environment}_glance_api_host"),        false),
  $keystone_api_host            = pick(getvar("${kickstack_environment}_keystone_api_host"),      false),
  $neutron_api_host             = pick(getvar("${kickstack_environment}_neutron_api_host"),       false),

  #Facts
  $glance_registry_host         = pick(getvar("${kickstack_environment}_glance_registry_host"),   false),
  $vncproxy_host                = pick(getvar("${kickstack_environment}_vncproxy_host"),          false),

  $nova_metadata_ip             = pick(getvar("${kickstack_environment}_nova_metadata_ip"),       false),
  $heat_cloudwatch_host         = pick(getvar("${kickstack_environment}_heat_cloudwatch_host"),   false),

  $memcached_hosts              = any2array(getvar("${kickstack_environment}_memcached_hosts"))
) {
  if (!defined(Class['kickstack'])) {
    fail('Kickstack is NOT defined...')
  }

  if (!$kickstack::enabled) {
    fail('Kickstack is not enabled ensure that $kickstack::enabled == true')
  }

  $missing_fact_template      = "'<%= @missing_fact %>' is missing and needed by '<%= @title %>' in the '${kickstack_environment}' kickstack environment. Ensure that provider class '<%= @class %>' is applied OR '<%= @missing_fact %>' is explicityly passed to kickstack."

  if ($allow_default_passwords) {
    $default_password_template  = "Default password for service '<%= @service_name %>'."
  } else {
    $default_password_template  = "Default password for service '<%= @service_name %>' and default passwords are not allowed."
  }

  $exported_fact_provider = {
    'db_host'               => 'kickstack::database::install',
    'rpc_host'              => 'kickstack::rpc',
    'ceilometer_api_host'   => 'kickstack::ceilometer::api',
    'nova_api_host'         => 'kickstack::nova::api',
    'cinder_api_host'       => 'kickstack::cinder::api',
    'heat_api_host'         => 'kickstack::heat::api',
    'heat_cfn_api_host'     => 'kickstack::heat::api',
    'glance_api_host'       => 'kickstack::glance::api',
    'keystone_api_host'     => 'kickstack::keystone::config',
    'neutron_api_host'      => 'kickstack::neutron::server',

    'glance_registry_host'  => 'kickstack::glance::registry',
    'vncproxy_host'         => 'kickstack::nova::vncproxy',

    'nova_metadata_ip'      => 'kickstack::nova::api',
  }

  if ($rpc_password == 'rpc_pass') {
    $base_message = 'Default rpc password'
    if ($allow_default_passwords) {
      warning("${base_message}.")
    } else {
      fail("${base_message} and default passwords are not allowed.")
    }
  }
}
