define tilde::user ($pubkey_type = 'ssh-rsa', $pubkey) {

  $username = $title
  $home = "/home/${username}"
  $channel = $tilde::irc::channel

  user { $username:
    ensure => present,
    managehome => true, # pick up our skel
    groups => ['town'],
    #notify => Exec["${username}_setquota"],
  }

  file { "${username}/.ssh":
    path => "/home/${username}/.ssh",
    ensure => directory,
    owner => $username,
    group => $username,
  } ->
  file { "${username}/.ssh/authorized_keys2":
    path => "$home/.ssh/authorized_keys2",
    ensure => file,
    owner => $username,
    group => $username,
  } ->
  ssh_authorized_key { "${username}_default":
    user   => $username,
    type   => $pubkey_type,
    key    => $pubkey,
    target => "${home}/.ssh/authorized_keys2",
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

  # custom to tilde.town

  file { "/home/${username}/.twurlrc":
    ensure => file,
    owner => $username,
    group => $username,
    replace => false,
    source => "puppet:///modules/tilde/twurlrc",
  }
}
