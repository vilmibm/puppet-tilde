define tilde::user ($pubkey_type = 'ssh-rsa', $pubkey) {

  $username = $title
  $home = "/home/${username}"
  $channel = $tilde::irc::channel

  user { $username:
    ensure => present,
    managehome => true, # pick up our skel
    groups => ['town'],
    notify => Exec["${username}_setquota"],
  }

  ssh_authorized_key { "${username}_default":
    user   => $username,
    type   => $pubkey_type,
    key    => $pubkey,
    target => "${home}/.ssh/authorized_keys2",
  }

  exec { "${username}_setquota":
    command => "/usr/sbin/setquota -u ${username} 20000 25000 0 0 -a",
    refreshonly => true,
  }

  file { "${home}/.irssi":
    ensure => directory,
    owner => $username,
    group => $username,
    mode => '0700',
  }

  file { "${home}/.irssi/config":
    ensure => file,
    owner => $username,
    group => $username,
    mode => '0600',
    content => template("${module_name}/irssi_config.erb"),
    replace => false,
  }


}
