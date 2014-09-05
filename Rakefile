#
# Rakefile - Configuration file for rake (http://rake.rubyforge.org/)
#
require 'falkorlib'

## placeholder for custom configuration of FalkorLib.config.*
## See https://github.com/Falkor/falkorlib

# Adapt the versioning aspects
FalkorLib.config.versioning do |c|
	c[:type] = 'puppet_module'
end

# Adapt the Git flow aspects
FalkorLib.config.gitflow do |c|
	c[:branches] = { 
		:master  => 'production',
		:develop => 'devel'
	} 
end

 
require 'falkorlib/tasks/git'
require 'falkorlib/tasks/puppet'

##############################################################################
#TOP_SRCDIR = File.expand_path(File.join(File.dirname(__FILE__), "."))

require 'rake/clean'
CLEAN.add   'pkg'

require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.send('disable_80chars')
# PuppetLint.configuration.send('disable_variable_scope')
# PuppetLint.configuration.send('disable_class_parameter_defaults')
# #TODO http://puppet-lint.com/checks/class_inherits_from_params_class/
# PuppetLint.configuration.send('disable_class_inherits_from_params_class')
# PuppetLint.configuration.fail_on_warnings = true

exclude_tests_paths = ['pkg/**/*','spec/**/*']
PuppetLint.configuration.ignore_paths = exclude_tests_paths
#PuppetSyntax.exclude_paths = exclude_tests_paths
