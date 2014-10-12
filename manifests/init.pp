class tilde ($use_quota = true, $addtl_packages, $users) {

  include tilde::packages
  include tilde::webserver
  include tilde::skel

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

  create_resources(tilde::user, $users)
  create_resources(package, $addtl_packages)
}
