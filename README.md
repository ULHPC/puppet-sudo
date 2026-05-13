# Sudo Puppet Module

[![Puppet Forge](http://img.shields.io/puppetforge/v/ULHPC/sudo.svg)](https://forge.puppetlabs.com/ULHPC/sudo)
[![License](http://img.shields.io/:license-GPL3.0-blue.svg)](LICENSE)
![Supported Platforms](http://img.shields.io/badge/platform-debian|redhat|centos-lightgrey.svg)

Configure and manage sudo and sudoers files

      Copyright (c) 2026 UL HPC Team <hpc-sysadmins@uni.lu>


| [Project Page](https://github.com/ULHPC/puppet-sudo) | [Sources](https://github.com/ULHPC/puppet-sudo) | [Issues](https://github.com/ULHPC/puppet-sudo/issues) |

## Synopsis

Manage sudo configuration via Puppet.

This module implements the following elements:

* __Puppet classes__:
    - `sudo`
    - `sudo::common`
    - `sudo::common::debian`
    - `sudo::common::redhat`
    - `sudo::params`

* __Puppet definitions__:
    - `sudo::alias::command`
    - `sudo::alias::host`
    - `sudo::alias::user`
    - `sudo::conf`
    - `sudo::defaults::spec`
    - `sudo::directive`

All these components are configured through a set of variables you will find in
[`manifests/params.pp`](manifests/params.pp).

## Dependencies

See [`metadata.json`](metadata.json). In particular, this module depends on

* [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)
* [puppetlabs/concat](https://forge.puppetlabs.com/puppetlabs/concat)

## Overview and Usage

### Class `sudo`

This is the main class defined in this module.
Use it as follows:

     include ' sudo'

### Definition `sudo::directive`

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

      sudo::directive {'vagrant':
        content => "%vagrant ALL=(ALL) NOPASSWD: ALL\n"
      }

On recent version of sudo, this will typically create a new file `/etc/sudoers.d/admin_users` (or `/etc/sudoers.d/vagrant`).

### Definition `sudo::alias::command`

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

### Definition `sudo::alias::user`

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

### Definition `sudo::defaults::spec`

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

## Librarian-Puppet / R10K Setup

You can of course configure the sudo module in your `Puppetfile` to make it available with [Librarian puppet](http://librarian-puppet.com/) or
[r10k](https://github.com/adrienthebo/r10k) by adding the following entry:

     # Modules from the Puppet Forge
     mod "ULHPC/sudo"

or, if you prefer to work on the git version:

     mod "ULHPC/sudo",
         :git => 'https://github.com/ULHPC/puppet-sudo',
         :ref => 'main'

## Developments / Issues / Contributing to the code

This Puppet Module has been implemented in the context of the [UL HPC](http://hpc.uni.lu) Platform of the [University of Luxembourg](http://www.uni.lu).
It relies on [Vox Pupuli modulesync](https://github.com/voxpupuli/modulesync) for its organization.

You can submit bugs / issues / feature requests using the [ULHPC-sudo Puppet Module Tracker](https://github.com/ULHPC/puppet-sudo/issues).
You are more than welcome to contribute to its development by [sending a pull request](https://help.github.com/articles/using-pull-requests).

## Licence

This project and the sources proposed within this repository are released under the terms of the [GPL-3.0](LICENCE) licence.


[![Licence](https://www.gnu.org/graphics/gplv3-88x31.png)](LICENSE)
