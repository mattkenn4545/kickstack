class kickstack::cinder::scheduler inherits kickstack::cinder {
  include kickstack::cinder::config
  if (defined(Class['::cinder'])) {
    class { '::cinder::scheduler':
      scheduler_driver  => 'cinder.scheduler.simple.SimpleScheduler',
      package_ensure    => $package_version
    }
  } else {
    notify { 'Unable to apply ::cinder::scheduler': }
  }
}
