class kickstack::nova::conductor inherits kickstack::nova {
  include kickstack::nova::config

  kickstack::nova::service { 'conductor': }
}
