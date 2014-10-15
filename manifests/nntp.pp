class tilde::nntp ($hostname) {

  package { 'inn2':
    ensure => installed,
  }

  file { '/etc/news/inn.conf':
    ensure => file,
    require => Package['inn2'],
    content => template("${module_name}/inn.conf.erb"),
  }

  file { '/etc/news/readers.conf':
    ensure => file,
    require => Package['inn2'],
    source => "puppet:///modules/${module_name}/readers.conf",
  }

  service { 'inn2':
    ensure => running,
    subscribe => [ File['/etc/news/inn.conf'], File['/etc/news/readers.conf'] ],
  }

  cron { 'expirenews':
    require => Package['inn2'],
    command => '/usr/lib/news/bin/expireover lowmark',
    user => 'news',
    hour => 23,
  }

}
