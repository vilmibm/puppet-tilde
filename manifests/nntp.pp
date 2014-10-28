class tilde::nntp ($hostname, $newsgroups = [], $peers = []) {

  File {
    notify => Service['inn2'],
  }

  package { ['inn2', 'slrn', 'tin']:
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

  file { '/etc/news/incoming.conf':
    ensure => file,
    require => Package['inn2'],
    content => template("${module_name}/incoming.conf.erb"),
  }

  file { '/etc/news/newsfeeds':
    ensure => file,
    require => Package['inn2'],
    content => template("${module_name}/newsfeeds.erb"),
  }

  file { '/etc/news/server':
    ensure => file,
    require => Package['inn2'],
    content => $hostname,
  }

  service { 'inn2':
    ensure => running,
    status => '/usr/sbin/innstat | /bin/grep "Server running"',
  }

  cron { 'expirenews':
    require => Package['inn2'],
    command => '/usr/lib/news/bin/expireover lowmark',
    user => 'news',
    hour => 23,
  }

  tilde::nntp::newsgroup { $newsgroups:
    require => Package['inn2'],
  }
}
