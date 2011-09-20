define redis::service($name = 'server', $config_file = '/etc/redis.conf') {
  
  file { "/etc/init.d/redis-${name}":
    content => template("redis/redis-server.erb"),
    owner   => root,
    group   => root,
    mode    => 744,
  }

}