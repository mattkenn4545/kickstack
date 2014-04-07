class kickstack::memcached {
  if (!$memcached_hosts) {
    $unset_parameter = 'memcached_hosts'
    $is_provided = true
  }

  if $unset_parameter {
    $message = inline_template($unset_parameter_template)
    notify { $message: }
  } else {
    class { '::memcached': }
  }
}
