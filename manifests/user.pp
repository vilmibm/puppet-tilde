define tilde::user ($pubkey_type = 'ssh-rsa', $pubkey) {

  $username = $title

  $channel = $tilde::irc::channel

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

  file { "/home/${username}/.irssi":
    ensure => directory,
    owner => $username,
    group => $username,
    mode => '0700',
  }

  file { "/home/${username}/.irssi/config":
    ensure => file,
    owner => $username,
    group => $username,
    mode => '0600',
    content => template("${module_name}/irssi_config.erb"),
    replace => false,
  }


}
