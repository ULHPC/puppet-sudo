# File::      <tt>sudo-alias-user.pp</tt>
# Author::    Sebastien Varrette (<Sebastien.Varrette@uni.lu>)
# Copyright:: Copyright (c) 2011 Sebastien Varrette (www[http://varrette.gforge.uni.lu])
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Define: sudo::alias::user
#
# Permits to define a user alias in the sudoers files (directive User_Alias)
# These aren't often necessary, as you can use regular groups
# (ie, from files, LDAP, NIS, etc) in this file - just use %groupname
# rather than USERALIAS
#
# == Pre-requisites
#
# * The class 'sudo' should have been instanciated
#
# == Parameters:
#
# [*userlist*]
#  List of users to add in the definition of the alias
#
# == Examples
#
#    sudo::alias::user{ 'ADMINS':
#          userlist => [ 'jsmith', 'mikem' ]
#    }
#
#    This will create the following entry in the sudoers files:
#    User_Alias ADMINS = jsmith, mikem
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define sudo::alias::user($userlist = []) {

    include sudo::params

    # $name is provided by define invocation
    # guid of this entry
    $groupname = $name

    concat::fragment { "sudoers_user_aliases_${groupname}":
        target  => "${sudo::params::configfile}",
        content => inline_template("User_Alias <%= groupname.upcase %> = <%= userlist.join(', ') %>\n"),
        ensure  => "${sudo::ensure}",
        order   => 25,
        notify  => Exec["${sudo::params::check_syntax_name}"],
    }
    
}





