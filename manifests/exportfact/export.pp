define kickstack::exportfact::export (
  $value
) {
  ::exportfact::export { "${kickstack::partition}_${name}":
    value     => $value,
    category  => $kickstack::partition
  }
}
