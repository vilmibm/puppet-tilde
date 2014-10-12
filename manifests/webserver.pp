class tilde::webserver {
  include nginx

  file { ['/var/www', '/var/www/tilde.town']:
    ensure => directory,
  }

  file { 'mainpage':
    path => '/var/www/tilde.town/index.html',
    content => 'welcome to tilde.town',
  }
}
