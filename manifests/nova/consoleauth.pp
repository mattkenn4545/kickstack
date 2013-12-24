class kickstack::nova::consoleauth inherits kickstack::nova {
  include kickstack::nova::config

  kickstack::nova::service { 'consoleauth': }
}
