class tilde ($use_quota = true, $addtl_packages = [], $users, $hostname) {

  include tilde::packages
  include tilde::mail
  include tilde::skel
  include tilde::irc

  class {'tilde::webserver':
    hostname => $hostname,
  }

  if ($use_quota) {
    include tilde::quota
  }

  group { 'town':
    ensure => present,
  }

  resources { 'user':
    purge => true,
    unless_system_user => true,
  }

  package { $addtl_packages:
    ensure => present,
  }

  create_resources(tilde::user, $users)
}
