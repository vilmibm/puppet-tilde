class tilde::webserver ($hostname) {
  include nginx

  $www_root = "/var/www/${hostname}"

  #$userlist = generate("/usr/local/bin/generate_userlist")
  $userlist = "under construction :3"
  $active_user_count = $::active_user_count

  file { ['/var/www', $www_root]:
    ensure => directory,
  }

  file { 'mainpage':
    ensure => file,
    path => "${www_root}/index.html",
    content => template("${module_name}/main_index.erb"),
    #source => "puppet:///modules/${module_name}/main_index.html",
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
