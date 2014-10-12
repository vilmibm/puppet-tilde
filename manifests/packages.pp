class tilde::packages {
  package { ['tmux',
             'irssi',
             'mutt',
             'irssi',
             'lynx',
             'tree',
             'finger',
             'cowsay']:

    ensure => present,

  }
}
