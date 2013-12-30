define kickstack::nova::service {
  # Installs the Nova service
  if (defined(Class['::nova'])) {
    $classname    = "::nova::${name}"

    class { $classname:
      enabled         => true,
      ensure_package  => $package_version
    }
  } else {
    notify { "Unable to apply ${classname}": }
  }
}
