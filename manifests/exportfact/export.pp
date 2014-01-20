define kickstack::exportfact::export (
  $value
) {
  ::exportfact::export { "${kickstack::kickstack_environment}_${name}":
    value     => $value,
    category  => $kickstack::kickstack_environment
  }
}
