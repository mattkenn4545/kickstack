class kickstack::nova::objectstore inherits kickstack::nova {
  include kickstack::nova::config

  kickstack::nova::service { 'objectstore': }
}
