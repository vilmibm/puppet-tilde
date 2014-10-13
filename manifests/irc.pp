class tilde::irc ($channel) {

  class { 'ngircd':
    server_name => 'localhost',
    dns => 'no',
  }

  ngircd::server { 'internal':
    host => 'localhost',
  }
}
