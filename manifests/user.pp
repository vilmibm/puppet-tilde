define tilde::user ($pubkey_type = 'ssh-rsa', $pubkey) {

  $username = $title
  $home = "/home/${username}"
  $channel = $tilde::irc::channel

  user { $username:
    ensure => present,
    managehome => true, # pick up our skel
    groups => ['town'],
    shell => '/bin/bash',
    notify => Exec["${username}_setquota"],
  }

  ssh_authorized_key { "${username}_default":
    user   => $username,
    type   => $pubkey_type,
    key    => $pubkey,
    target => "${home}/.ssh/authorized_keys2",
  }

  file { "${username}/.ssh":
    path => "/home/${username}/.ssh",
    ensure => directory,
    owner => $username,
    group => $username,
  }

  file { "${username}_poetry_key":
    require => File["${username}/.ssh"],
    ensure => file,
    path => "/home/${username}/.ssh/poetry",
    owner => $username,
    group => $username,
    mode => 600,
    source => "puppet:///modules/tilde/poetry_key",
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

  # custom to tilde.town

  file { "/home/${username}/.twurlrc":
    ensure => file,
    owner => $username,
    group => $username,
    replace => false,
    source => "puppet:///modules/tilde/twurlrc",
  }

  exec { "${username} welcome present":
    command => "/usr/local/bin/welcome_present ${username}",
    creates => "/home/${username}/welcome_${username}",
    require => User[$username],
  }
}
