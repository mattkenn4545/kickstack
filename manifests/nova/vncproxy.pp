class kickstack::nova::vncproxy inherits kickstack::nova {
  if (!$vncproxy_host) {
    $unset_parameter = 'vncproxy_host'
    $is_provided = true
  }

  if $unset_parameter {
    $message = inline_template($unset_parameter_template)
    notify { $message: }
  } else {
    include kickstack::nova::config

    if (defined(Class['::nova'])) {
      class { '::nova::vncproxy':
        enabled         => true,
        host            => getvar("ipaddress_${nic_management}"),
        ensure_package  => $package_version
      }
    } else {
      notify { 'Unable to apply ::nova::vncproxy': }
    }
  }
}
