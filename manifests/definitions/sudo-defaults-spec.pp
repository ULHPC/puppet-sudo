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
#  Specify the contents of the Defaults directive as a string. Newlines, tabs,
#  and spaces can be specified using the escaped syntax (e.g., \n for a newline)
#  Note that each line SHOULD start by 'Defaults' -- see sudoers(5)
#
# [*source*]
#  Copy a file as the content of the Defaults directive.
#  Uses checksum to determine when a file
#  should be copied. Valid values are either fully qualified paths to files, or
#  URIs. Currently supported URI types are puppet and file.
#  If content was not specified, you are expected to use the source
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
define sudo::defaults::spec($content='', $source='') {

    include sudo::params

    # $name is provided by define invocation
    # guid of this entry
    $defaultname = $name
    
    # if content is passed, use that, else if source is passed use that
    case $content {
        '': {
            case $source {
                '': {
                    crit('No content nor source have been  specified')
                }
                default: { $real_source = $source }
            }
        }
        default: { $real_content = $content }
    }

    concat::fragment { "sudoers_defaults_spec_${defaultname}":
        target  => "${sudo::params::configfile}",
        ensure  => "${sudo::ensure}",
        order   => 65,
        content => $real_content,
        source  => $real_source,
        notify  => Exec["${sudo::params::check_syntax_name}"],
    }

}





