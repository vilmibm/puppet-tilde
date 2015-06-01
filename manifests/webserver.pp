class tilde::webserver ($hostname) {
  include nginx

  $www_root = "/var/www/${hostname}"

  file { ['/var/www', $www_root]:
    ensure => directory,
  }

  file { 'index page':
    ensure => file,
    replace => false,
    path => "${www_root}/index.html",
    content => template("${module_name}/basic_main_index.erb")
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
