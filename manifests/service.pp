define redis::service(
    $name = 'server', 
    $config_file = '/etc/redis.conf',
    $enable_service = true, 
    $version = '2.2.13',
    $path = '/usr/local/src',
    $bin = '/usr/local/bin',
    $owner = 'redis',
    $group = 'redis',
    $db_folder  = '/var/lib/redis'
) {
  
  $full_name = "redis-${name}"
  
  file { "/etc/init.d/${full_name}":
    content => template("redis/redis-server.erb"),
    owner   => root,
    group   => root,
    mode    => 744,
    notify  => Service[$full_name]
  }
  
  file { $db_folder:
      ensure  => directory
    , owner   => $owner
    , group   => $group
  }
  
  service { $full_name:
      enable      => $enable_service
    , ensure      => $enable_service
    , hasrestart  => true
    , require     => [File["/etc/init.d/${full_name}"], Class['redis'], File[$db_folder]]
  }

}