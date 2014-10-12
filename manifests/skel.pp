class tilde::skel {
  
  file { 'skel':
    ensure => directory,
    path => '/etc/skel',
    source => "puppet:///modules/${module_name}/skel",
    recurse => true,
    owner => 'root',
    group => 'root',
  }
  
}
