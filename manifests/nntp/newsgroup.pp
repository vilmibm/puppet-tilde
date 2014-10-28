define tilde::nntp::newsgroup () {
  # TODO the paths for inn stuff in here will change based on
  # platform.

  exec { "add ${title}":
    command => "/usr/sbin/ctlinnd newgroup ${title}",
    unless => "/bin/grep ${title} /var/lib/news/active",
    notify => Service['inn2'],
  }

  file_line { "subscriptions ${title}":
    path => '/etc/news/subscriptions',
    line => $title,
  }

}
