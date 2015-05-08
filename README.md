-*- mode: markdown; mode: visual-line;  -*-

# Sudo Puppet Module 

[![Puppet Forge](http://img.shields.io/puppetforge/v/ULHPC/sudo.svg)](https://forge.puppetlabs.com/ULHPC/sudo)
[![License](http://img.shields.io/:license-GPL3.0-blue.svg)](LICENSE)
![Supported Platforms](http://img.shields.io/badge/platform-debian-lightgrey.svg)

Configure and manage sudo and sudoers files

      Copyright (c) 2015 S. Varrette, H. Cartiaux, V. Plugaru <hpc-sysadmins@uni.lu>
      

* [Online Project Page](https://github.com/ULHPC/puppet-sudo)  -- [Sources](https://github.com/ULHPC/puppet-sudo) -- [Issues](https://github.com/ULHPC/puppet-sudo/issues)

## Synopsis

Manage sudo configuration via Puppet.

This module implements the following elements: 

* __Puppet classes__:
    - `sudo` 
    - `sudo::common` 
    - `sudo::debian` 
    - `sudo::params` 
    - `sudo::redhat` 

* __Puppet definitions__: 
    - `sudo::alias::command` 
    - `sudo::alias::user` 
    - `sudo::defaults::spec` 
    - `sudo::directive` 

All these components are configured through a set of variables you will find in
[`manifests/params.pp`](manifests/params.pp). 

_Note_: the various operations that can be conducted from this repository are piloted from a [`Rakefile`](https://github.com/ruby/rake) and assumes you have a running [Ruby](https://www.ruby-lang.org/en/) installation.
See [`doc/contributing.md`](doc/contributing.md) for more details on the steps you shall follow to have this `Rakefile` working properly. 

## Dependencies

See [`metadata.json`](metadata.json). In particular, this module depends on 

* [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)
* [puppetlabs/concat](https://forge.puppetlabs.com/puppetlabs/concat)

## Overview and Usage

### Class `sudo`

This is the main class defined in this module.
It accepts the following parameters: 

* `$ensure`: default to 'present', can be 'absent'

Use is as follows:

     include ' sudo'

See also [`tests/init.pp`](tests/init.pp)

### Class `sudo`

See `tests/sudo.pp`
### Class `sudo::common`

See `tests/sudo/common.pp`
### Class `sudo::debian`

See `tests/sudo/debian.pp`
### Class `sudo::params`

See `tests/sudo/params.pp`
### Class `sudo::redhat`

See `tests/sudo/redhat.pp`

### Definition `sudo::alias::command`

The definition `sudo::alias::command` provides ...
This definition accepts the following parameters:

* `$ensure`: default to 'present', can be 'absent'
* `$content`: specify the contents of the directive as a string
* `$source`: copy a file as the content of the directive.

Example:

        sudo::alias::command { 'toto':
		      ensure => 'present',
        }

See also `tests/sudo/alias/command.pp`

### Definition `sudo::alias::user`

The definition `sudo::alias::user` provides ...
This definition accepts the following parameters:

* `$ensure`: default to 'present', can be 'absent'
* `$content`: specify the contents of the directive as a string
* `$source`: copy a file as the content of the directive.

Example:

        sudo::alias::user { 'toto':
		      ensure => 'present',
        }

See also `tests/sudo/alias/user.pp`

### Definition `sudo::defaults::spec`

The definition `sudo::defaults::spec` provides ...
This definition accepts the following parameters:

* `$ensure`: default to 'present', can be 'absent'
* `$content`: specify the contents of the directive as a string
* `$source`: copy a file as the content of the directive.

Example:

        sudo::defaults::spec { 'toto':
		      ensure => 'present',
        }

See also `tests/sudo/defaults/spec.pp`

### Definition `sudo::directive`

The definition `sudo::directive` provides ...
This definition accepts the following parameters:

* `$ensure`: default to 'present', can be 'absent'
* `$content`: specify the contents of the directive as a string
* `$source`: copy a file as the content of the directive.

Example:

        sudo::directive { 'toto':
		      ensure => 'present',
        }

See also `tests/sudo/directive.pp`


## Librarian-Puppet / R10K Setup

You can of course configure the sudo module in your `Puppetfile` to make it available with [Librarian puppet](http://librarian-puppet.com/) or
[r10k](https://github.com/adrienthebo/r10k) by adding the following entry:

     # Modules from the Puppet Forge
     mod "ULHPC/sudo"

or, if you prefer to work on the git version: 

     mod "ULHPC/sudo", 
         :git => https://github.com/ULHPC/puppet-sudo,
         :ref => production 

## Issues / Feature request

You can submit bug / issues / feature request using the [ULHPC/sudo Puppet Module Tracker](https://github.com/ULHPC/puppet-sudo/issues). 

## Developments / Contributing to the code 

If you want to contribute to the code, you shall be aware of the way this module is organized. 
These elements are detailed on [`doc/contributing.md`](doc/contributing.md)

You are more than welcome to contribute to its development by [sending a pull request](https://help.github.com/articles/using-pull-requests). 

## Puppet modules tests within a Vagrant box

The best way to test this module in a non-intrusive way is to rely on [Vagrant](http://www.vagrantup.com/).
The `Vagrantfile` at the root of the repository pilot the provisioning various vagrant boxes available on [Vagrant cloud](https://atlas.hashicorp.com/boxes/search?utf8=%E2%9C%93&sort=&provider=virtualbox&q=svarrette) you can use to test this module.

See [`doc/vagrant.md`](doc/vagrant.md) for more details. 


