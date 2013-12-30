class kickstack::horizon::site inherits kickstack::horizon {
   if (!$auth_host) {
     $missing_fact = 'auth_host'
   }

  if $missing_fact {
    $class = $exported_fact_provider[$missing_fact]

    if (defined(Class[$class])) {
      $message = inline_template($missing_fact_warn)
      notify { $message: }
    } else {
      $message = inline_template($missing_fact_fail)
      fail($message)
    }
  } else {
    if $debug {
      $django_debug = 'True'
      $log_level    = 'DEBUG'
    } elsif $verbose {
      $django_debug = 'False'
      $log_level    = 'INFO'
    } else {
      $django_debug = 'False'
      $log_level    = 'WARNING'
    }

    class { '::horizon':
      secret_key            => $secret_key,
      fqdn                  => $allow_any_hostname ? {
                                 true => '*',
                                 default => pick($fqdn, $hostname)
                               },
      cache_server_ip       => '127.0.0.1',
      cache_server_port     => '11211',
      swift                 => false,
      keystone_host         => $auth_host,
      keystone_default_role => 'Member',
      django_debug          => $django_debug,
      api_result_limit      => 1000,
      log_level             => $log_level,
      can_set_mount_point   => 'True',
      listen_ssl            => false
    }
  }
}
