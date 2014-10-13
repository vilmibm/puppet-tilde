class tilde::mail {
  include postfix

  postfix::config { 'inet_interfaces':
    value => 'localhost'
  }

  postfix::config { 'default_transport':
    value => 'error: outside mail not deliverable'
  }
}
