import "defines/*.pp"

class redis($enable_service = true) {
    
    user { "redis":
      ensure => present,
    }
    
    redis_source { git: 
        owner           => "redis",
        group           => "redis",
        require         => User["redis"],
        enabled_service => $enable_service
    }
}
