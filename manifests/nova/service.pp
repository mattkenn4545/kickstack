define kickstack::nova::service {
  $servicename  = $name
  $classname    = "::nova::${servicename}"

  # Installs the Nova service
  class { $classname:
    enabled         => true,
    ensure_package  => $package_version
  }
}
