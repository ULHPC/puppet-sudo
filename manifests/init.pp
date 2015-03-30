# File::      <tt>init.pp</tt>
# Author::    Sebastien Varrette (Sebastien.Varrette@uni.lu)
# Copyright:: Copyright (c) 2011 Sebastien Varrette
# License::   GPL v3
#
# ------------------------------------------------------------------------------
# = Class: sudo
#
# Configure and manage sudo and sudoers files
#
# == Actions
#
# Install and configure sudo
#
# == Parameters (cf sudo-params.pp)
#
# $ensure:: *Default*: 'present'. The Puppet ensure attribute (can be either 'present' or 'absent') - absent will ensure the sudo package is removed
#
# == Requires
#
# n/a
#
# == Sample Usage
#
#     import sudo
#
# You can then specialize the various aspects of the configuration,
# for instance
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
class sudo(
  $ensure     = $sudo::params::ensure,
  $configfile = $sudo::params::configfile
  ) inherits sudo::params
{
    info ("Configuring sudo (with ensure = ${ensure})")

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("sudo 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    case $::operatingsystem {
        debian, ubuntu:         { include sudo::debian }
        redhat, fedora, centos: { include sudo::redhat }
        default: {
            fail("Module ${module_name} is not supported on ${::operatingsystem}")
        }
    }
}

# ------------------------------------------------------------------------------
# = Class: sudo::common
#
# Base class to be inherited by the other sudo classes
#


