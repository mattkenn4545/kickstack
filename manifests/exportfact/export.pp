define kickstack::exportfact::export (
  $value
) {
  ::exportfact::export { "${kickstack::params::partition}_${name}":
    value     => $value,
    category  => $kickstack::params::partition
  }
}
