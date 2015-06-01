class tilde (
  $users,
  $hostname,
  $use_quota = true,
  $addtl_packages = [],
  $newsgroups = [],
  $newspeers = []
) {

  include tilde::packages
  include tilde::mail
  include tilde::skel
  include tilde::irc

  File { backup => false, }

  class { 'tilde::nntp':
    hostname => $hostname,
    newsgroups => $newsgroups,
    peers => $newspeers,
  }

  class { 'tilde::webserver':
    hostname => $hostname,
  }

  if ($use_quota) {
    include tilde::quota
  }

  if ($enable_wiki) {
    include tilde::wiki
  }

  resources { 'user':
    purge => true,
    unless_system_user => true,
  }

  package { $addtl_packages:
    ensure => present,
  }

  file { 'motd':
    ensure => file,
    replace => false,
    path => "/etc/motd",
    content => template("${module_name}/motd.erb")
  }

  create_resources(tilde::user, $users)

}
