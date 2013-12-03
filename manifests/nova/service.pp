define kickstack::nova::service {
  $classname    = "::nova::${name}"

  # Installs the Nova service
  class { $classname:
    enabled         => true,
    ensure_package  => $package_version
  }
}
