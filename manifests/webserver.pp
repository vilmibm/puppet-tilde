class tilde::webserver ($hostname) {
  include nginx

  file { ['/var/www', "/var/www/${hostname}"]:
    ensure => directory,
  }

  file { 'mainpage':
    path => "/var/www/${hostname}/index.html",
    content => "welcome to ${hostname}",
  }
}
