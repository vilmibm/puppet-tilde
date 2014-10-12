class tilde ($use_quota = true) {

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

  create_resources(tilde::user, hiera('tilde::users'))
}
