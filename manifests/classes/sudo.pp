# File::      <tt>sudo.pp</tt>
# Author::    Sebastien Varrette (Sebastien.Varrette@uni.lu)
# Copyright:: Copyright (c) 2011 Sebastien Varrette
# License::   GPL v3
#
# ------------------------------------------------------------------------------
# = Class: sudo
#
# Configure and manage sudo and sudoers files
#
# == Actions:
#
# Install and configure sudo
#
# == Parameters: (cf sudo-params.pp)
#
# $ensure:: *Default*: 'present'. The Puppet ensure attribute (can be either 'present' or 'absent') - absent will ensure the sudo package is removed
#
# == Requires:
#
# n/a
#
# == Sample Usage:
#
#     import sudo
#
# You can then specialize the various aspects of the configuration,
# for instance:
#
#         class { 'sudo':  }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
#
# [Remember: No empty lines between comments and class definition]
#
class sudo( $ensure = $sudo::params::ensure ) inherits sudo::params
{
    info ("Configuring sudo (with ensure = ${ensure})")

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("sudo 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    case $::operatingsystem {
        debian, ubuntu:         { include sudo::debian }
        redhat, fedora, centos: { include sudo::redhat }
        default: {
            fail("Module $module_name is not supported on $operatingsystem")
        }
    }
}

# ------------------------------------------------------------------------------
# = Class: sudo::common
#
# Base class to be inherited by the other sudo classes
#
# Note: respect the Naming standard provided here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
class sudo::common {

    # Load the variables used in this module. Check the ssh-server-params.pp file
    require sudo::params

    package { 'sudo':
        name    => "${sudo::params::packagename}",
        ensure  => "${sudo::ensure}",
    }

    include concat::setup

    # TODO: if $ensure == 'present'
    concat { "${sudo::params::configfile}":
        owner   => "${sudo::params::configfile_owner}",
        group   => "${sudo::params::configfile_group}",
        mode    => "${sudo::params::configfile_mode}",
        require => Package['sudo'],
        #ensure  => "${sudo::ensure}",
        #content => template("sudo/sudoconf.erb"),
        #notify  => Service['sudo'],
    }

    # Header of the file
    concat::fragment { "sudoers_header":
        target  => "${sudo::params::configfile}",
        source  => "puppet:///modules/sudo/01-sudoers_header",
        ensure  => "${sudo::ensure}",
        order   => 01,
    }

    # Header of the User aliases
    concat::fragment { "sudoers_user_aliases_header":
        target  => "${sudo::params::configfile}",
        source  => "puppet:///modules/sudo/20-sudoers_user_aliases_header",
        ensure  => "${sudo::ensure}",
        order   => 20,
    }


    # Header of the Command aliases
    concat::fragment { "sudoers_command_aliases_header":
        target  => "${sudo::params::configfile}",
        content => template("sudo/40-sudoers_command_aliases_header.erb"),
        ensure  => "${sudo::ensure}",
        order   => 40,
    }


    # Header of the Defaults specs
    concat::fragment { "sudoers_default_specs_header":
        target  => "${sudo::params::configfile}",
        content => template("sudo/60-sudoers_default_specs.erb"),
        ensure  => "${sudo::ensure}",
        order   => 60,
    }


    # Header of the main part
    concat::fragment { "sudoers_mainheader":
        target  => "${sudo::params::configfile}",
        source  => "puppet:///modules/sudo/80-sudoers_main_header",
        ensure  => "${sudo::ensure}",
        order   => 80,
    }

    #notice("sudoversion = $sudoversion")

    if versioncmp($sudoversion,'1.7.1') > 0 {
        #
        # Use the #includedir directive to manage sudoers.d, version >= 1.7.2
        #
        concat::fragment { "sudoers_footer_includedir":
            target  => "${sudo::params::configfile}",
            content => "\n#includedir ${sudo::params::configdir}\n",
            ensure  => "${sudo::ensure}",
            order   => 99,
        }

        file { "${sudo::params::configdir}":
            ensure  => 'directory',
            owner   => "${sudo::params::configdir_owner}",
            group   => "${sudo::params::configdir_group}",
            mode    => "${sudo::params::configdir_mode}",
            purge   => true,
            recurse => true,
        }

    }

    # check the syntax of the sudoers files
    exec {"${sudo::params::check_syntax_name}":
        path      => "/usr/bin:/usr/sbin:/bin",
        command   => "visudo -c -f ${sudo::params::configfile}",
        returns   => 0,
        logoutput => 'on_failure',
    }


}


# ------------------------------------------------------------------------------
# = Class: sudo::debian
#
# Specialization class for Debian systems
class sudo::debian inherits sudo::common { }

# ------------------------------------------------------------------------------
# = Class: sudo::redhat
#
# Specialization class for Redhat systems
class sudo::redhat inherits sudo::common { }



