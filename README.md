# puppet-tilde

This is an experimental, alpha Puppet module for setting up an Ubuntu server in
the style of [tilde.club](http://tilde.club).

What is in master is generally guaranteed to have been tested casually
on an AWS EC2 micro running Ubuntu 14.04 at [tilde.town](http://tilde.town), but aside from that, there are
no guarantees about the code. YMMV. I'm trying to keep the README up
to date as I change things / add features.

## Installation

 _All of these steps assume you are running as the `root` user._

 * Install the `puppet` and `puppetmaster` packages (they can be on the same
   server). 3.4.x+ is required.
 * `puppet module install jfryman-nginx -v 0.0.10` (must install v0.0.10, [see here](https://github.com/jfryman/puppet-nginx/issues/460))
 * `apt-get install -y puppetmaster puppet git-core`.
 * `puppet module install hunner-charybdis`
 * `puppet module install camptocamp-postfix`
 * Set up hiera:
  * add a [hiera.yaml](https://github.com/nathanielksmith/puppet-tilde/tree/master/examples/hiera.yaml) to `/etc/puppet/`
  * `ln -s /etc/puppet/hiera.yaml /etc/hiera.yaml`
  * `mkdir /etc/puppet/hieradata`
  * add and **configure** [common.yaml](https://github.com/nathanielksmith/puppet-tilde/tree/master/examples/common.yaml) to `/etc/puppet/hieradata/`
 * `cd /etc/puppet/modules`
 * `git clone https://github.com/nathanielksmith/puppet-tilde.git tilde`
 * edit [site.pp](https://github.com/nathanielksmith/puppet-tilde/tree/master/examples/site.pp) and save to `/etc/puppet/manifests/site.pp`
 * `puppet agent -t --server={your_tilde_host_name}`

## Adding Users

To add users to your tilde server, add them to your `common.yaml` (or whatever) like so:

    tilde::users:
      vilmibm:
        pubkey: '...'
      cmr:
        pubkey: '...'
      datagrok:
        pubkey: '...'

The module purges any non-system users not managed by Puppet; in other words,
to ban a user, simply delete them from the `tilde::users` hash in `common.yaml`.

You can also specify `pubkey_type` in the user hash if the user is
fancy and not using `ssh-rsa`. The supported types are whatever is
supported by puppet's
[authorized key type](https://docs.puppetlabs.com/references/latest/type.html#sshauthorizedkey)

Password based logins are not currently supported. You'll have to
manually enable that if you want it.

## /etc/skel

`/etc/skel` is managed as a set of files in the module. If you'd like to
modify these, make a local branch on the module and edit away. You can
add or remove files from the directory (note, old users will not
retroactively get changes to `/etc/skel`).

## Nginx

Currently, the module looks for `tilde::hostname` (e.g. _tilde.town_
or _tilde.farm_ or _drawbridge.club_) and sets up an Nginx virtual host with:


 * a homepage for your tilde server (`/var/www/<your
 domain>/index.html`)
 * user directories (`/~<username>`) which map to `/home/<username>/public_html`
 * server names `$hostname` and `www.$hostname`
 * **IMPORTANT** Make sure port 80 is open for your server.

## IRC

The module sets up the charybdis IRC server for you.

 * `irc` alias added to users' `.bashrc` file.
 * per-user irssi config this will auto-connect to the server and auto-join
   #<hostname> where hostname is a .-less string substitution of the hostname
   you specified as `tilde::hostname`.
 * Your localhost root user will have OPER privileges in IRC, using the password you configured in your `common.yaml` file.

## Mail

The module sets up postfix for you. Just like tilde.club, it's local
mail only. Alpine and mutt are installed by default.

## MotD

There is basic Message of the Day support. The motd is laid out for you but you
can directly edit it at `/etc/motd`. Puppet does not manage the file after first
generating it. The included template just has a basic cowsay with a few
instructions (and shows your server's hostname).

A `motd` alias that just runs `cat /etc/motd` is also added by the
aliases file in `/etc/skel`.

## NNTP (Usenet)

The program `inn2` is set up and configured for local access. The clients `slrn`, `tin`, and `alpine` are all installed by default. In order to transfer news with peers, you must enable both inbound and outbound traffic on TCP port 119 (for EC2 users, this may mean editing your security groups, for others it may mean editing iptables rules).

**IMPORTANT**: Make sure port 119 is open for your server.

**IMPORTANT**: Refer to [the example common.yaml file](https://github.com/nathanielksmith/puppet-tilde/tree/master/examples/common.yaml) to see how to configure newsgroups/peers. No groups are configured by default.

## Quota support

This module can enable 3mb user quotas for all non-system users. You'll need to
add the usrquota option to your / mount with something like this in your
`site.pp`, though, for it to work:

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

Quota is opt in. Enable it in `site.pp` like so:

    class { 'tilde':
        enable_quota => true,
    }

Or configure `common.yaml` with:

    tilde::enable_quota: true 

## Bootleg wiki

A pseudo-user, `wiki`, with a world-editable home directory serves as a janky
sort of wiki. Adding version control after the fact is recommended. Enable this
via site.pp with:

    class { 'tilde':
        enable_wiki => true,
    }

Or configure `common.yaml` with:

    tilde::enable_wiki: true 

## TODO

 * Flags for switching on/off various services from `common.yaml` (if
   you don't want NTTP, for example).
 * Support for non-ubuntu OSes
 * (tested) support for non-ec2 platforms

## Authors

 * Nathaniel Smith <nks@lambdaphil.es>
 * Chris Roddy <cmr@mdc2.org>
 * Jason Levine <jason@queso.com>

## License

This module is licensed under the terms of the GNU Public License version 3
(GPLv3)
