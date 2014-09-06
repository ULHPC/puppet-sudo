# File::      <tt>params.pp</tt> 
# Author::    Sebastien Varrette (<Sebastien.Varrette@uni.lu>)
# Copyright:: Copyright (c) 2014 Sebastien Varrette (www[http://varrette.gforge.uni.lu])
# License::   GPLv3
# 
# ------------------------------------------------------------------------------
# You need the 'future' parser to be able to execute this manifest (that's
# required for the each loop below).
#
# Thus execute this manifest as follows:
#
#      sudo puppet apply -t --parser future /vagrant/tests/params.pp
#
#

include 'sudo::params'

$names = [
          'packagename', 'configfile', 'backupconfigfile',
          'configfile_mode', 'configfile_owner', 'configfile_group',
          'configdir', 'configdir_mode', 'configdir_group',
          'check_syntax_name', 'cmdalias_pkgmanager'
          ]

each($names) |$v| {
    $var = "sudo::params::${v}"
    notice("${var} = ", inline_template('<%= scope.lookupvar(@var) %>'))
}

