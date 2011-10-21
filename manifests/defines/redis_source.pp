define redis_source(
    $enable_service,
    $version = '2.4.1',
    $path = '/usr/local/src',
    $bin = '/usr/local/bin',
    $owner = 'redis',
    $group = 'redis'
) {
    case $version {
        default: {
             file { redis_folder:
                 path => "${path}/redis_${version}",
                 ensure => "directory",
                 owner => root,
                 group => root
             }
             exec { redis_code: 
                  command =>"wget http://github.com/antirez/redis/tarball/${version} -O redis_${version}.tar.gz && tar --strip-components 1 -xzvf redis_${version}.tar.gz",
                  cwd => "${path}/redis_${version}",
                  creates => "${path}/redis_${version}/redis.c",
                  require => File["redis_folder"],
                  before => Exec["make ${version}"]
             }
             file { "${path}/redis_${version}/redis_${version}.tar.gz":
                  ensure => absent,
                  require => Exec["redis_code"]
             }

        }
        source: {
             exec { "git clone git://github.com/antirez/redis.git redis_${version}":
                 cwd => "${path}",
                 creates => "${path}/redis_${version}/.git/HEAD",
                 before => Exec["make ${version}"]
             }
        }
    }
    
    exec { "make ${version}":
         cwd => "${path}/redis_${version}",
         command => "make && mv redis-server ${bin}/ && mv redis-cli ${bin}/ && mv redis-benchmark ${bin}/ && mv redis-check-dump ${bin}/",
         creates => "${bin}/redis-server",
    }
    
    file { db_folder:
        path => "/var/lib/redis",
        ensure => "directory",
        owner => $owner,
        group => $group,
    }
    
    redis::service { 'default_redis_service': 
      enable_service  => $enable_service
    }
    
    file { "/etc/redis.conf":
        ensure => present,
        content => template("redis/redis.conf.erb"),
        replace => false;
    }
}
