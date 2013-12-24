class kickstack::nova::scheduler inherits kickstack::nova {
  include kickstack::nova::config

  kickstack::nova::service { 'scheduler': }
}
