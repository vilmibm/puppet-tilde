define tilde::nntp::newsgroup ($name) {
  # TODO the paths for inn stuff in here will change based on
  # platform.

  exec { "add ${name}":
    command => "/usr/lib/bin/news/ctlinnd newgroup ${name}",
    unless => "/bin/grep ${name} /var/lib/news/active",
  }

  file_line { "subscriptions ${name}":
    path => '/etc/news/subscriptions',
    line => $name,
  }

}
