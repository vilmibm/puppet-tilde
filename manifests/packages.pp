class tilde::packages {
  package { ['tmux',
             'htop',
             'screen',
             'alpine',
             'emacs',
             'irssi',
             'mutt',
             'lynx',
             'tree',
             'finger',
             'cowsay']:

    ensure => present,

  }
}
