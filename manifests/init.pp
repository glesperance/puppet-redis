import "defines/*.pp"

class redis($enable_service = true) {
    
    user { "redis":
      ensure => present,
    }
    
    redis_source { 'redis-source': 
        owner           => "redis",
        group           => "redis",
        require         => User["redis"],
        enable_service  => $enable_service
    }
    
    augeas { 'sysctl':
      context => '/files/etc/sysctl.conf',
      changes => [
        'set vm.overcommit_memory =1'
      ]
    }

}
