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

  user { 'wiki':
    ensure => present,
    managehome => true,
  }

  file { '/home/wiki':
    ensure => directory,
    owner => 'wiki',
    mode => '0777'
  }

 # mount { '/':
 #   ensure  => 'mounted',
 #   device  => 'LABEL=cloudimg-rootfs',
 #   dump    => '0',
 #   fstype  => 'ext4',
 #   options => 'defaults,discard,usrquota',
 #   pass    => '0',
 #   target  => '/etc/fstab',
 # }




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

  file { "/etc/motd":
    ensure => file,
    owner => root,
    group => root,
    mode => '0665',
    content => template("${module_name}/motd.erb")
  }

  create_resources(tilde::user, $users)

}
