define kickstack::endpoint (
  $service_password,
  $servicename        = $name,
  $classname          = 'auth'
) {
  $fullclassname = "::${servicename}::keystone::${classname}"

  # Installs the service user endpoint.
  class { $fullclassname:
    password          => $service_password,
    public_address    => "${fqdn}${kickstack::keystone::public_suffix}",
    admin_address     => "${fqdn}${kickstack::keystone::admin_suffix}",
    internal_address  => $fqdn,
    region            => $kickstack::keystone::region,
    require           => Class['::keystone']
  }
}
