define kickstack::nova::service {
  $classname    = "::nova::${name}"

  # Installs the Nova service
  if (defined(Class['::nova'])) {
    class { $classname:
      enabled         => true,
      ensure_package  => $package_version
    }
  } else {
    notify { "Unable to apply ${classname}": }
  }
}
