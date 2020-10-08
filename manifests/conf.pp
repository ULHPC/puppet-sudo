# File::      <tt>conf.pp</tt>
# Author::    Hyacinthe Cartiaux (<Hyacinthe.Cartiaux@uni.lu>)
# Copyright:: Copyright (c) 2020 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Define: sudo::conf
#
#  The definition sudo::conf is a compatibility definition for saz/sudo
#  All parameters are passed to sudo::directive
#
# == Pre-requisites
#
# * The class 'sudo' should have been instanciated
#
# == Parameters:
#
# [*ensure*]
#   default to 'present', can be 'absent' (BEWARE: it will remove the associated
#   file)
#   Default: 'present'
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
# [*priority*]
#  This parameter is ignored
#
# [*sudo_file_name]
#   Name of the file in /etc/sudoers.d. If empty, $name is used
#
# == Examples
#
#        sudo::conf {'admin_users':
#           content => "%admin ALL=(ALL) ALL\n",
#        }
#
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define sudo::conf(
    $content        = '',
    $source         = '',
    $priority       = 0,
    $sudo_file_name = '',
    $ensure         = 'present'
)
{
    if ($sudo_file_name != '') {
        $dname = $sudo_file_name
    } else {
        $dname = $name
    }

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("sudo::directive 'ensure' parameter must be set to either 'absent', or 'present'")
    }
    if ($sudo::ensure != $ensure) {
        if ($sudo::ensure != 'present') {
            fail("Cannot configure the sudo directive '${dname}' as sudo::ensure is NOT set to present (but ${sudo::ensure})")
        }
    }

    sudo::directive {$dname:
       ensure  => $ensure,
       content => $content,
       source  => $source,
    }


}
