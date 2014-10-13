# puppet-tilde

This is an experimental, alpha Puppet module for setting up an ubuntu server in
the style of [tilde.club](http://tilde.club).

What is in master is generally guaranteed to have been tested casually
on an ec2 micro running Ubuntu 14.04 at [tilde.town](http://tilde.town), but aside from that, there are
no guarantees about the code. YMMV. I'm trying to keep the README up
to date as I change things / add features.

## Installation

 _All of these steps assume you are running as the root user._

 * Install puppet and puppetmaster (they can be on the same
   server). 3.4.x+ is required.
 * `puppet module install nginx`
 * Set up hiera:
  * add a [hiera.yaml](https://github.com/nathanielksmith/puppet-tilde/tree/master/examples/hiera.yaml) to `/etc/puppet/`
  * `ln -s /etc/puppet/hiera.yaml /etc/hiera.yaml`
  * `mkdir /etc/puppet/hieradata`
  * add and **configure** [common.yaml](https://github.com/nathanielksmith/puppet-tilde/tree/master/examples/common.yaml) to `/etc/puppet/hieradata/`
 * `cd /etc/puppet/modules; git clone https://github.com/nathanielksmith/puppet-tilde.git tilde`
 * edit [site.pp](https://github.com/nathanielksmith/puppet-tilde/tree/master/examples/site.pp)
 * `puppet agent -t`

## Adding Users

To add users to your tilde server, add them to your common.yaml (or whatever) like so:

    tilde::users:
      vilmibm:
        pubkey: '...'
      cmr:
        pubkey: '...'
      datagrok:
        pubkey: '...'

The module purges any non-system users not managed by puppet; in other words,
to ban a user, simply delete them from the tilde::users hash in common.yaml.

You can also specify `pubkey_type` in the user hash if the user is
fancy and not using `ssh-rsa`. The supported types are whatever is
supported by puppet's
[authorized key type](https://docs.puppetlabs.com/references/latest/type.html#sshauthorizedkey)

## Nginx

Currently, the module looks for `tilde::hostname` (e.g. _tilde.town_
or _tilde.farm_ or _drawbridge.club_) and sets up an nginx vhost with:


 * a homepage for your tilde server (`/var/www/<your
 domain>/index.html`)
 * user directories (`/~<username>`) which map to /home/<username>/public_html
 * server names $hostname and www.$hostname

## Quota support

This module enables 3mb user quotas for all non-system users. You'll
need to add the usrquota option to your / mount with something like
this in your `site.pp`, though, for it to work:

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

If you **do not want disk quotas**, include the tilde class like this
in your `site.pp`:

    class { 'tilde':
        use_quota => false,
    }

or configure common.yaml with

    tilde::use_quota: false

## IRC

The module sets up ngircd for you.

 * localhost only
 * "irc" alias added to users' .bashrc
 * per-user irssi config this will auto-connect to the
   server and auto-join #<hostname> where hostname is a .-less string
   substitution of the hostname you specified as `tilde::hostname`.

It does **not** set up an operator. IRC governance is up to the
autonomous collective to determine.

## Authors

 * Nathaniel Smith <nks@lambdaphil.es>
 * Chris Roddy <cmr@mdc2.org>

## License

This module is licensed under the terms of the GNU Public License version 3
(GPLv3)
