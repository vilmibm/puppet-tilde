define tilde::user ($pubkey_type = 'ssh-rsa', $pubkey) {

  $username = $title

  user { $username:
    ensure => present,
    managehome => true, # pick up our skel
    groups => ['town'],
    notify => Exec["${username}_setquota"],
  }

  ssh_authorized_key { "${username}_default":
    user => $username,
    type => $pubkey_type,
    key  => $pubkey,
  }

  exec { "${username}_setquota":
    command => "/usr/sbin/setquota -u ${username} 3112 4000 0 0 -a",
    refreshonly => true,
  }
}
