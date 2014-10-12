# Obviously, put in your hostname here:
node 'tilde.town' {

  # All configuration is done via hiera, but if you want you can do:
  # class { 'tilde':
  #   use_quota => false,
  #   addtl_packages => ['angband'],
  # }
  include tilde

  # This is to set usrquota to enable user filesystem quotas. There's
  # no need for this block if you are not going to use quotas.
  mount { '/':
    ensure  => 'mounted',
    device  => 'LABEL=cloudimg-rootfs',
    dump    => '0',
    fstype  => 'ext4',
    options => 'defaults,discard,usrquota',
    pass    => '0',
    target  => '/etc/fstab',
  }
}
