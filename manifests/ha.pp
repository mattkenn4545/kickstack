class kickstack::ha (
  $balance    =   'roundrobin'
) inherits kickstack::params {
  class { 'haproxy': }

  haproxy::listen { 'admin':
    ports     => '8080',
    ipaddress => $ipaddress_eth1,
    options   => { 'mode' => [ 'http' ] }
  }

  $ha_services = [ 'keystone', 'neutron', 'heat', 'cinder', 'glance', 'ceilometer', 'nova' ]

  kickstack::ha::service { $ha_services: }

  Haproxy::Listen <| title != 'admin'|> {
    ipaddress => $ipaddress_eth1,
    options   => {
      'balance' => $balance,
      'option'  => [
        'tcplog',
        'tcpka'
      ]
    }
  }
}

define kickstack::ha::service {
  $service_ports = {
    'keystone'    => [ '5000', '35357' ],
    'neutron'     => [ '9696' ],
    'heat'        => [ '8004' ],
    'cinder'      => [ '8776' ],
    'glance'      => [ '9292' ],
    'nova'        => [ '8773', '8774', '8775' ],
    'ceilometer'  => [ '8777' ]
  }

  kickstack::ha::listener{ $service_ports[$name]: service => $name }
}

define kickstack::ha::listener ($service) {
  haproxy::listen { "${service}-${name}":
    ports             => $name,
    collect_exported  => true
  }
}
