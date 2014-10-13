class tilde::mail {

  class {'postfix':
    inet_interfaces => 'localhost',
  }

  postfix::config { 'default_transport':
    value => 'error: outside mail not deliverable'
  }
}
