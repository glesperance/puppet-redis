import "defines/*.pp"

class redis($enable_service = true) {
    
    user { "redis":
      ensure => present,
      bin    => $bin
    }
    
    redis_source { git: 
        owner           => "redis",
        group           => "redis",
        require         => User["redis"],
        enable_service  => $enable_service
    }
}
