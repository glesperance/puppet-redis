define redis::service(
    $enable_service = true,

    $path = '/usr/local/src',
    $bin = '/usr/local/bin',

    $owner = 'redis',
    $group = 'redis',

    $redis_service_name = 'redis', 
    $redis_port         = 6379,
    $redis_maxmemory    = '500MB',
    $redis_appendonly   = 'yes',

    $config_file = "/etc/${redis_service_name}.conf",
    $db_folder  = "/var/lib/${redis_service_name}"
) {

  file { "/etc/init.d/${redis_service_name}":
    content => template("redis/redis-server.erb"),
    owner   => root,
    group   => root,
    mode    => 744,
    notify  => Service[$redis_service_name]
  }

  file { $config_file:
    content => template('redis/redis.conf.erb'),
    owner   => root,
    group   => root,
    mode    => 744,
    notify  => Service[$redis_service_name]
  }
  
  file { $db_folder:
      ensure  => directory
    , owner   => $owner
    , group   => $group
  }
  
  service { $redis_service_name:
      enable      => $enable_service
    , ensure      => $enable_service
    , hasrestart  => true
    , require     => [File["/etc/init.d/${redis_service_name}"], File[$config_file], Class['redis'], File[$db_folder]]
  }

}