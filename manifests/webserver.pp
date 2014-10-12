class tilde::webserver ($hostname) {
  include nginx

  $www_root = "/var/www/${hostname}"

  file { ['/var/www', $www_root]:
    ensure => directory,
  }

  file { 'mainpage':
    ensure => file,
    path => "${www_root}/index.html",
    source => "puppet:///modules/${module_name}/main_index.html",
  }

  nginx::resource::vhost { $hostname:
    ensure => present,
    use_default_location => false,
    server_name => ["www.${hostname}", $hostname],
  }

  nginx::resource::location { 'main':
    ensure => present,
    vhost => $hostname,
    location => '/',
    www_root => $www_root,
  }

  nginx::resource::location { 'userContent':
    ensure => present,
    location => '~ "^/~(.+?)(/.*)?$"',
    vhost => $hostname,
    location_alias => '/home/$1/public_html$2',
  }
}
