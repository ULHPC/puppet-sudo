# File::      <tt>directive.pp</tt>
# Author::    Sebastien Varrette (<Sebastien.Varrette@uni.lu>)
# Copyright:: Copyright (c) 2011 Sebastien Varrette (www[http://varrette.gforge.uni.lu])
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Define: sudo::directive
#
#  The definition sudo::directive provides a simple way to write sudo
#  configurations parts.
#  If you want do define aliases for users (resp. commands), consider using
#  sudo::alias::user (resp. sudo::alias::command).
#  If you want to configure 'Defaults' specifications, consider using
#  sudo::defaults::spec.
#  If you use a sudo version >= 1.7.2, the sudo directive part is validated via
#  visudo and removed if syntax is not correct.
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
# == Examples
#
#        sudo::directive {'admin_users':
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
define sudo::directive(
    $content = '',
    $source  = '',
    $ensure  = 'present'
)
{
    include ::sudo::params

    # $name is provided by define invocation
    # guid of this entry
    $dname = $name

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("sudo::directive 'ensure' parameter must be set to either 'absent', or 'present'")
    }
    if ($sudo::ensure != $ensure) {
        if ($sudo::ensure != 'present') {
            fail("Cannot configure the sudo directive '${dname}' as sudo::ensure is NOT set to present (but ${sudo::ensure})")
        }
    }

    # if content is passed, use that, else if source is passed use that
    $real_content = $content ? {
        '' => undef,
        default => $source ? {
            ''      => "${content}\n",
            default => undef
        }
    }

    $real_source = $source ? {
        '' => undef,
        default => $content ? {
            ''      => $source,
            default => undef
        }
    }

    if($::sudoversion != undef){
        if versioncmp($::sudoversion,'1.7.2') < 0 {
            concat::fragment { "sudoers_directive_${dname}":
                target  => $sudo::configfile,
                order   => 65,
                content => $real_content,
                source  => $real_source,
                notify  => Exec[$sudo::params::check_syntax_name],
            }
        }
        else
        {
            # here sudo version >= 1.7.2
            #
            # The #includedir directive is present to manage sudoers.d, version >= 1.7.2
            #
            file {"${sudo::configdir}/${dname}":
                ensure  => $ensure,
                owner   => $sudo::params::configfile_owner,
                group   => $sudo::params::configfile_group,
                mode    => $sudo::params::configfile_mode,
                content => $real_content,
                source  => $real_source,
                notify  => Exec["${sudo::params::check_syntax_name} for ${sudo::params::configdir}/${dname}"],
                require => File[$sudo::configdir],
                #Package['sudo'],
            }

            if $sudo::ensure == 'present' {
                # check the syntax of the created files, delete it if the syntax is wrong
                exec {"${sudo::params::check_syntax_name} for ${sudo::params::configdir}/${dname}":
                    path        => '/usr/bin:/usr/sbin:/bin',
                    command     => "visudo -c -f ${sudo::params::configdir}/${dname} || ( rm -f ${sudo::params::configdir}/${dname} && exit 1)",
                    returns     => 0,
                    logoutput   => 'on_failure',
                    refreshonly => true,
                }

            }
        }
    }
}





