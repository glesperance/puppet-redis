define redis::service($name = 'server', $config_file = '/etc/redis.conf', $enable_service = true) {
  
  $full_name = "redis-${name}"
  
  file { "/etc/init.d/${full_name}":
    content => template("redis/redis-server.erb"),
    owner   => root,
    group   => root,
    mode    => 744,
  }
  
  service { $full_name:
      enable      => $enable_service
    , ensure      => $enable_service
    , hasrestart  => true
    , require     => File["/etc/init.d/${full_name}"]
  }

}