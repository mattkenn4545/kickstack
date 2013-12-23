class kickstack::keystone::params (
    $admin_token,
    $admin_password,
    $admin_tenant,
    $region,
    $public_suffix,
    $admin_suffix,
    $service_tenant,
    $admin_email
) inherits kickstack::params {
  $service_name = 'keystone'
}
