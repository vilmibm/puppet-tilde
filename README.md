# puppet-tilde

This is an experimental, alpha Puppet module for setting up an ubuntu server in
the style of [tilde.club](http://tilde.club).

## example usage

Put it in /etc/puppet/modules. It's not on the Forge yet, sorry.

Your site.pp should look something like this:

        node 'tilde.town' {
        
          include tilde
        
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

The mount resource is specified so that we may set `usrquota`. This is needed
for user disk quotas, which are set up automagically. If you don't want quotas
(they are hardcoded to 3mb per user) disable them as so:

        class { 'tilde':
          use_quota => false,
        }

instead of using `include tilde`.

## Configuration

**You'll need to set up hiera data**. See the great docs
[here](https://docs.puppetlabs.com/hiera/1/puppet.html). Also note that the
nginx module we use requires `puppet_module_data` to be enabled. Your
hiera.yaml will end up looking something like this:

        :hierarchy:
          - common
        
        :backends:
          - yaml
          - module_data
        
        :yaml:
          :datadir: /etc/puppet/hieradata

 

### Users

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

You can also specify `pubkey_type` in the user hash if the user is fancy and not using `ssh-rsa`. The supported types are whatever is supported by puppet's [authorized key type](https://docs.puppetlabs.com/references/latest/type.html#sshauthorizedkey)

### Nginx

This module sets up nginx (as opposed to httpd, which the original tilde.club
runs). Your configuration will look like this (feel free to copy and paste and
just change the hostname):

        nginx::nginx_vhosts:
          'tilde.town':
            use_default_location: false
            server_name:
              - 'www.tilde.town'
              - 'tilde.town'
            
        nginx::nginx_locations:
          'main':
            location: '/'
            vhost: 'tilde.town'
            www_root: '/var/www/tilde.town'
        
          'userContent':
            location: '~ "^/~(.+?)(/.*)?$"'
            vhost: 'tilde.town'
            location_alias: '/home/$1/public_html$2'

This sets up a homepage for your tilde server (`/var/www/<your
domain>/index.html`) as well as the user directories (`/~<username>`).

## Authors

 * Nathaniel Smith <nks@lambdaphil.es>
 * Chris Roddy <cmr@mdc2.org>

## License

This module is licensed under the terms of the GNU Public License version 3
(GPLv3) 
