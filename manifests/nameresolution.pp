# Simple convenience class for name resolution.
#
# Exports the current host's name, along with the IP address
# associated with the management NIC.
#
# Currently supports only entries in /etc/hosts. Alternative
# implementations might dynamically manage DNS entries.
class kickstack::nameresolution inherits kickstack::params {
  include kickstack::keystone

  case $name_resolution {
    'hosts': {
      $host = pick($fqdn, $hostname)
      if $fqdn {
        $aliases = [ $hostname,  "${hostname}${kickstack::keystone::admin_suffix}"]
      } else {
        $aliases = [ "${hostname}${kickstack::keystone::admin_suffix}" ]
      }

      @@host { $host:
        ip            => getvar("ipaddress_${nic_management}"),
        host_aliases  => $aliases,
        comment       => 'Managed by Puppet',
        tag           => "${kickstack_environment}_name_resolution"
      }
      Host <<| tag == "${kickstack_environment}_name_resolution" |>>
    }

    default: {
      fail("Unsupported value for \$name_resolution: ${name_resolution}")
    }
  }
}
