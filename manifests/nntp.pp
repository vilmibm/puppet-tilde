class tilde::nntp ($hostname) {

  package { ['inn2', 'slrn']:
    ensure => installed,
    notify => [ Exec['local.tilde'], Exec['local.html'], Exec['local.music'] ],
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

  exec { 'local.tilde':
    command => '/usr/sbin/ctlinnd newgroup local.tilde',
    refreshonly => true,
  }

  exec { 'local.html':
    command => '/usr/sbin/ctlinnd newgroup local.tilde',
    refreshonly => true,
  }

  exec { 'local.music':
    command => '/usr/sbin/ctlinnd newgroup local.tilde',
    refreshonly => true,
  }
}
