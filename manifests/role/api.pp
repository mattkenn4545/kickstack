class kickstack::role::api inherits kickstack {
#  include kickstack::glance::api
  include kickstack::cinder::api
#
#  include kickstack::neutron::server
#  include kickstack::neutron::plugin
#
#  include kickstack::heat::api
#  include kickstack::ceilometer::api
#
#  if $keystone_internal_address and $nova_sql_conn and $amqp_host and $amqp_password {
#    include kickstack::nova::api
#
#    # This looks a bit silly, but is currently necessary: in order to configure nova-api
#    # as a Neutron client, we first need to install nova-api and neutron-server in one
#    # run, and then fix up Nova with the Neutron configuration in the next run.
#    $neutron_keystone_password = getvar("${fact_prefix}neutron_keystone_password")
#    if $neutron_keystone_password {
#      include kickstack::nova::neutronclient
#    }
#  }
}
