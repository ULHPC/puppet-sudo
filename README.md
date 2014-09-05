-*- mode: markdown; mode: auto-fill; fill-column: 80 -*-

# Sudo Puppet Module 

[![Puppet Forge](http://img.shields.io/puppetforge/v/ULHPC/sudo.svg)](https://forge.puppetlabs.com/ULHPC/sudo)
[![License](http://img.shields.io/:license-gpl3.0-blue.svg)](LICENSE)
![Supported Platforms](http://img.shields.io/badge/platform-debian|redhat|centos-lightgrey.svg)

Configure and manage sudo and sudoers files

      Copyright (c) 2011-2014 S. Varrette, H. Cartiaux, V. Plugaru <hpc-sysadmins@uni.lu>
      

* [Online Project Page](https://github.com/ULHPC/puppet-sudo)  -- [Sources](https://github.com/ULHPC/puppet-sudo) -- [Issues](https://github.com/ULHPC/puppet-sudo/issues)

## Synopsis

Manage sudo configuration via Puppet.
This module implements the following elements: 

* __classes__:     `sudo`
* __definitions__: 
  * `sudo::directive`:  generic way to write sudoers configurations parts;
  * `sudo::alias::command`: defines a command alias in the sudoers files (directive `Cmnd_Alias`)
  * `sudo::alias::user`: defines a user alias in the sudoers files (directive `User_Alias`)
  * `sudo::defaults::spec`: defines a default specifications (directive `Defaults`)

The various operations of this repository are piloted from a `Rakefile` which
assumes that you have [RVM](https://rvm.io/) installed on your system.

## Dependencies

See [`metadata.json`](metadata.json). In particular, this module depends on 

* [puppetlabs/concat](https://forge.puppetlabs.com/puppetlabs/concat)

## General Parameters

See [manifests/params.pp](manifests/params.pp)

## Overview and Usage

### class `sudo`

     include 'sudo'

### definition `sudo::directive`

The definition `sudo::directive` provides a simple way to write sudo configurations parts.
If you use a `sudo` version >= 1.7.2, the sudo directive part is validated via
`visudo` and removed if syntax is not correct.
This definition accepts the following parameters:

* `$ensure`: default to 'present', can be 'absent' (BEWARE: it will remove the
  associated file) 
* `$content`: specify the contents of the directive as a string
* `$source`: copy a file as the content of the directive.

Example:

      sudo::directive {'admin_users':
           content => "%admin ALL=(ALL) ALL\n",
      }

### definition `sudo::defaults::spec`

Permits to define a default specifications
This definition accepts the following parameters:

* `$ensure`: default to 'present', can be 'absent' 
* `$content`: specify the contents of the directive as a string
* `$source`: copy a file as the content of the directive.

Examples

     sudo::defaults::spec { 'env_keep':
           content => "
      Defaults    env_reset
      Defaults    env_keep =  \"COLORS DISPLAY HOSTNAME LS_COLORS\"
      Defaults    env_keep += \"MAIL PS1 PS2 USERNAME LANG LC_ADDRESS LC_CTYPE\"
      Defaults    env_keep += \"LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES\"
      Defaults    env_keep += \"LC_TIME LC_ALL LANGUAGE\"\n",
      }

This will create the following entry in the sudoers files:

```
Defaults    env_reset
Defaults    env_keep =  "COLORS DISPLAY HOSTNAME LS_COLORS"
Defaults    env_keep += "MAIL PS1 PS2 USERNAME LANG LC_ADDRESS LC_CTYPE"
Defaults    env_keep += "LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES"
Defaults    env_keep += "LC_TIME LC_ALL LANGUAGE"
```

### definition `sudo::alias::command`

Permits to define a command alias in the `sudoers` files (directive `Cmnd_Alias`)
These are groups of related commands...

This definition accepts the following parameters:

* `$ensure`: default to 'present', can be 'absent' 
* `$commandlist`: List of commands to add in the definition of the alias

Example: 

     sudo::alias::command{ 'NETWORK':
          cmdlist => [ '/sbin/route', '/sbin/ifconfig', '/bin/ping', '/sbin/dhclient', '/sbin/iptables' ]
     }

This will create the following entry in the sudoers files:

     ## Networking
     Cmnd_Alias NETWORK = /sbin/route, /sbin/ifconfig, /bin/ping, /sbin/dhclient, /sbin/iptables

### definition `sudo::alias::user`

Permits to define a user alias in the sudoers files (directive User_Alias)
These aren't often necessary, as you can use regular groups
(ie, from files, LDAP, NIS, etc) in this file - just use `%groupname`
rather than `USERALIAS`

This definition accepts the following parameters:

* `$ensure`: default to 'present', can be 'absent' 
* `$commandlist`: list of users to add in the definition of the alias

Example:

      sudo::alias::user{ 'ADMINS':
          userlist => [ 'jsmith', 'mikem' ]
      }

This will create the following entry in the `sudoers` files:

      User_Alias ADMINS = jsmith, mikem


## Librarian-Puppet / R10K Setup

You can of course configure ULHPC-sudo in your `Puppetfile` to make it 
available with [Librarian puppet](http://librarian-puppet.com/) or
[r10k](https://github.com/adrienthebo/r10k) by adding the following entry:

     # Modules from the Puppet Forge
     mod "ULHPC/sudo"

or, if you prefer to work on the git version: 

     mod "ULHPC/sudo", 
         :git => 'https://github.com/ULHPC/puppet-sudo',
         :ref => 'production' 

## Issues / Feature request

You can submit bug / issues / feature request using the 
[ULHPC/sudo Puppet Module Tracker](https://github.com/ULHPC/puppet-sudo/issues). 


## Developments / Contributing to the code 

If you want to contribute to the code, you shall be aware of the way this module
is organized.
These elements are detailed on [`doc/contributing.md`](doc/contributing.md)

You are more than welcome to contribute to its development by 
[sending a pull request](https://help.github.com/articles/using-pull-requests). 

## Tests on Vagrant box

The best way to test this module in a non-intrusive way is to rely on
[Vagrant](http://www.vagrantup.com/). The `Vagrantfile` at the root of the
repository pilot the provisioning of the vagrant box and relies on boxes
generated through my [vagrant-vms](https://github.com/falkor/vagrant-vms)
repository.  
Once cloned, run 

      $> rake packer:Debian:init
      
To create a template. Select the version matching the once mentioned on the
`Vagrantfile` (`7.6.0-amd64` for instance)
Then run 

      $> rake packer:Debian:build
      
This shall generate the vagrant box `debian-7.6.0-amd64.box` that you can then
add to your box lists: 

      $> vagrant box add debian-7.6.0-amd64  packer/debian-7.6.0-amd64/debian-7.6.0-amd64.box

Now you can run `vagrant up` from this repository to boot the VM, provision it
to be ready to test this module (see the [`.vagrant_init.rb`](.vagrant_init.rb)
script). For instance, you can test the manifests of the `tests/` directory
within the VM: 

      $> vagrant ssh 
      [...]
      (vagrant)$> sudo puppet apply -t /vagrant/tests/init.pp
      
From now on, you can test (with `--noop`) the other manifests. For instance: 

      (vagrant)$> sudo puppet apply -t --noop /vagrant/tests/directive.pp 

Run `vagrant halt` (or `vagrant destroy`) to stop (or kill) the VM once you've
finished to play with it. 

## Resources

### Git 

You should become familiar (if not yet) with Git. Consider these resources: 

* [Git book](http://book.git-scm.com/index.html)
* [Github:help](http://help.github.com/mac-set-up-git/)
* [Git reference](http://gitref.org/)

