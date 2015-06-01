define tilde::templatedfile ($template, $path, $owner='root', $group='root', $mode='0665') {

  $rendered_path = "/tmp/rendered_${template}"

  file { $rendered_path:
    ensure => file,
    content => template($template),
  } ->
  exec { "cp ${template} to ${path}":
    command => "/bin/cp ${rendered_path} ${path}",
    creates => $path,
  }
}
