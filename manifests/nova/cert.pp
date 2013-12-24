class kickstack::nova::cert inherits kickstack::nova {
  include kickstack::nova::config

  kickstack::nova::service { 'cert': }
}
