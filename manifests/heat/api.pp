class kickstack::heat::api inherits kickstack::heat {
  include kickstack::heat::config

  if (defined(Class['::heat'])) {
    $enabled_apis = split($apis, ',')

    if 'heat' in $enabled_apis {
      class { '::heat::api':
        enabled           => true
      }

      kickstack::endpoint { 'heat':
        service_password  => $service_password,
        require           => Class[ '::heat::api' ]
      }

      kickstack::exportfact::export { 'heat_metadata_host':
        require           => Class[ '::heat::api' ]
      }
    }

    if 'cfn' in $enabled_apis {
      class { '::heat::api_cfn':
        enabled           => true
      }

      kickstack::endpoint { 'heat_cfn':
        servicename       => 'heat',
        classname         => 'auth_cfn',
        service_password  => $cfn_service_password,
        require           => Class[ '::heat::api_cfn' ]
      }
    }

    if 'cloudwatch' in $enabled_apis {
      class { '::heat::api_cloudwatch':
        enabled           => true
      }

      kickstack::exportfact::export { 'heat_cloudwatch_host':
        require           => Class[ '::heat::api_cloudwatch' ]
      }

      # The puppet-heat module has no facility for setting up the
      # CloudWatch Keystone endpoint.
    }
  } else {
    notify { 'Unable to apply heat apis': }
  }
}
