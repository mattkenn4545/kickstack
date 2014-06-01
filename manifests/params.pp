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

  #Infrastructure
  $db_host                      = pick($db_host,                false),
  $rpc_host                     = pick($rpc_host,               false),

  #Endpoint Hosts
  $haproxy_host                 = undef,

  $ceilometer_api_host          = pick($haproxy_host, $ceilometer_api_host,     false),
  $nova_api_host                = pick($haproxy_host, $nova_api_host,           false),
  $cinder_api_host              = pick($haproxy_host, $cinder_api_host,         false),
  $heat_api_host                = pick($haproxy_host, $heat_api_host,           false),
  $heat_cfn_api_host            = pick($haproxy_host, $heat_cfn_api_host,       false),
  $glance_api_host              = pick($haproxy_host, $glance_api_host,         false),
  $keystone_api_host            = pick($haproxy_host, $keystone_api_host,       false),
  $neutron_api_host             = pick($haproxy_host, $neutron_api_host,        false),

  #Other Hosts
  $glance_registry_host         = pick($glance_registry_host,   false),
  $vncproxy_host                = pick($vncproxy_host,          false),

  $nova_metadata_ip             = pick($nova_metadata_ip,       false),

  $memcached_hosts              = split(pick($memcached_hosts, ','), ',')
) {
  if (!defined(Class['kickstack'])) {
    fail('Kickstack is NOT defined...')
  }

  if (!$kickstack::enabled) {
    fail('Kickstack is not enabled ensure that $kickstack::enabled == true')
  }

  $unset_parameter_template      = "'<%= @unset_parameter %>' is missing and needed by '<%= @title %>'. Ensure that '<%= @unset_parameter %>' is passed to kickstack. <% if @is_provided %> '<%= @hostname %>' is eligible to become the '<%= @unset_parameter %>'.<% end %>"

  if ($allow_default_passwords) {
    $default_password_template  = "Default password for service '<%= @service_name %>'."
  } else {
    $default_password_template  = "Default password for service '<%= @service_name %>' and default passwords are not allowed."
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
