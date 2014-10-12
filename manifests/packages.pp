class tilde::packages {
  package { ['tmux',
             'irssi',
             'mutt',
             'lynx',
             'tree',
             'finger',
             'cowsay']:

    ensure => present,

  }
}
