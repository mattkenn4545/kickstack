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
  $db_host              = pick(getvar("${kickstack_environment}_db_host"),                false),
  $rpc_host             = pick(getvar("${kickstack_environment}_rpc_host"),               false),

  #Keystone
  $auth_host            = pick(getvar("${kickstack_environment}_auth_host"),              false),

  #Glance
  $glance_registry_host = pick(getvar("${kickstack_environment}_glance_registry_host"),   false),
  $glance_api_host      = pick(getvar("${kickstack_environment}_glance_api_host"),        false),

  #Neutron
  $neutron_host         = pick(getvar("${kickstack_environment}_neutron_host"),           false),

  #Heat
  $heat_metadata_host   = pick(getvar("${kickstack_environment}_heat_metadata_host"),     false),
  $heat_cloudwatch_host = pick(getvar("${kickstack_environment}_heat_cloudwatch_host"),   false),

  #Nova
  $vncproxy_host        = pick(getvar("${kickstack_environment}_vncproxy_host"),          false),
  $nova_metadata_ip     = pick(getvar("${kickstack_environment}_nova_metadata_ip"),       false)
) {
  if (!defined(Class['kickstack'])) {
    fail('Kickstack is NOT defined...')
  }

  $missing_fact_template      = "'<%= @missing_fact %>' exported fact missing which is needed by '<%= @title %>'. Ensure that provider class '<%= @class %>' is applied in the ${kickstack_environment} kickstack_environment."

  if ($allow_default_passwords) {
    $default_password_template  = "Default password for service '<%= @service_name %>'."
  } else {
    $default_password_template  = "Default password for service '<%= @service_name %>' and default passwords are not allowed."
  }

  $exported_fact_provider = {
    'db_host'               => 'kickstack::database::install',
    'rpc_host'              => 'kickstack::rpc',
    'auth_host'             => 'kickstack::keystone::config',
    'glance_registry_host'  => 'kickstack::glance::registry',
    'glance_api_host'       => 'kickstack::glance::api',
    'neutron_host'          => 'kickstack::neutron::server',
    'heat_metadata_host'    => 'kickstack::heat::api',
    'heat_cloudwatch_host'  => 'kickstack::heat::api',
    'vncproxy_host'         => 'kickstack::nova::vncproxy',
    'nova_metadata_ip'      => 'kickstack::nova::api',
  }
}
