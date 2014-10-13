class tilde::quota {
  package { ['quota', 'linux-image-extra-virtual']:
    ensure => installed,
  }

  file_line { 'quota modules':
    require => Package['linux-image-extra-virtual'],
    path => '/etc/modules',
    line => 'quota_v2',
    notify => Exec['quota_modprobe'],
  }

  exec { 'quota_modprobe':
    command => '/sbin/modprobe quota_v2',
    refreshonly => true,
  }

  exec { 'quotas':
    require => Package['linux-image-extra-virtual'],
    command => '/sbin/quotacheck -cum /',
    creates => '/aquota.user',
    cwd => '/',
    notify => Exec['quotaon'],
  }

  exec { 'quotaon':
    command => '/sbin/quotaon /',
    refreshonly => true,
  }
}
