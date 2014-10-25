class tilde::irc {

  $channel = regsubst($tilde::hostname, '\.', '')

  class { 'ngircd':
    server_name => 'localhost',
    max_nick_length => 20,
    dns => 'no',
  }

  ngircd::server { 'internal':
    host => 'localhost',
  }
}
