# File::      <tt>sudo-defaults_spec.pp</tt>
# Author::    Sebastien Varrette (<Sebastien.Varrette@uni.lu>)
# Copyright:: Copyright (c) 2011 Sebastien Varrette (www[http://varrette.gforge.uni.lu])
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Define: sudo::defaults::spec
#
# Permits to define a defaultd specifications
#
# == Pre-requisites
#
# * The class 'sudo' should have been instanciated
#
# == Parameters:
#
# [*content*]
#  content of the Defaults directive (it SHOULD start by default)
#
# == Examples
#
#        sudo::defaults::spec { 'env_keep':
#        content => "
#Defaults    env_reset
#Defaults    env_keep =  \"COLORS DISPLAY HOSTNAME LS_COLORS\"
#Defaults    env_keep += \"MAIL PS1 PS2 USERNAME LANG LC_ADDRESS LC_CTYPE\"
#Defaults    env_keep += \"LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES\"
#Defaults    env_keep += \"LC_TIME LC_ALL LANGUAGE\"\n",
#    }
#
#    This will create the following entry in the sudoers files:
#
#    Defaults    env_reset
#    Defaults    env_keep =  "COLORS DISPLAY HOSTNAME LS_COLORS"
#    Defaults    env_keep += "MAIL PS1 PS2 USERNAME LANG LC_ADDRESS LC_CTYPE"
#    Defaults    env_keep += "LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES"
#    Defaults    env_keep += "LC_TIME LC_ALL LANGUAGE"
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define sudo::defaults::spec($content='') {

    include sudo::params

    # $name is provided by define invocation
    # guid of this entry
    $defaultname = $name

    $real_content = $content ? {
        ''      => undef,
        default => $content,
    }

    concat::fragment { "sudoers_defaults_spec_${defaultname}":
        target  => "${sudo::params::configfile}",
        content => $real_content,
        ensure  => "${sudo::ensure}",
        order   => 65,
        notify  => Exec["${sudo::params::check_syntax_name}"],
    }
    
}





