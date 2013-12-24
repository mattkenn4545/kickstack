class kickstack::cinder::scheduler inherits kickstack::cinder {
  include kickstack::cinder::config

  class { '::cinder::scheduler':
    scheduler_driver  => 'cinder.scheduler.simple.SimpleScheduler',
    package_ensure    => $package_version
  }
}
