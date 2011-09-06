# File::      <tt>sudo-alias-command.pp</tt>
# Author::    Sebastien Varrette (<Sebastien.Varrette@uni.lu>)
# Copyright:: Copyright (c) 2011 Sebastien Varrette (www[http://varrette.gforge.uni.lu])
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Define: sudo::alias::command
#
# Permits to define a command alias in the sudoers files (directive Cmnd_Alias)
# These are groups of related commands...
#
# == Pre-requisites
#
# * The class 'sudo' should have been instanciated
#
# == Parameters:
#
# [*commandlist*]
#  List of commands to add in the definition of the alias
#
# == Examples
#
#    sudo::alias::command{ 'NETWORKING':
#          cmdlist => [ '/sbin/route', '/sbin/ifconfig', '/bin/ping', '/sbin/dhclient', '/sbin/iptables' ]
#    }
#
#    This will create the following entry in the sudoers files:
#
#    ## Networking
#    Cmnd_Alias NETWORKING = /sbin/route, /sbin/ifconfig, /bin/ping, /sbin/dhclient, /sbin/iptables
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define sudo::alias::command($cmdlist = []) {

    include sudo::params

    # $name is provided by define invocation
    # guid of this entry
    $groupname = $name

    concat::fragment { "sudoers_ommand_aliases_${groupname}":
        target  => "${sudo::params::configfile}",
        content => inline_template("## <%= groupname.capitalize %>\nCmnd_Alias <%= groupname.upcase %> = <%= cmdlist.join(', ') %>\n"),
        ensure  => "${sudo::ensure}",
        order   => 45,
        notify  => Exec["${sudo::params::check_syntax_name}"],
    }
    
}





