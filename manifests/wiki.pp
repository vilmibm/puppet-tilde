class tilde::wiki {
  user { 'wiki':
    ensure => present,
    managehome => true,
  }

  file {'/home/wiki':
    ensure => directory,
    owner => 'wiki',
    mode => '0777'
  }
}
