class tilde::irc ($channel) {

  $channel = regsubst($tilde::hostname, '\.', ''),

  class { 'ngircd':
    server_name => 'localhost',
    dns => 'no',
  }

  ngircd::server { 'internal':
    host => 'localhost',
  }
}
