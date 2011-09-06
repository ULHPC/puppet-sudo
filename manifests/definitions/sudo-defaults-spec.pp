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
#    sudo::defaults::spec{ 'keep_LC':
#          content => "Defaults env_keep = \"LC_TIME LC_ALL LANGUAGE\""
#    }
#
#    This will create the following entry in the sudoers files:
#
#    Defaults env_keep = "LC_TIME LC_ALL LANGUAGE"
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





