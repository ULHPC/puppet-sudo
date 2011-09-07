name       'sudo'
version    '0.1.0'
source     'git-admin.uni.lu:puppet-repo.git'
author     'Sebastien Varrette (Sebastien.Varrette@uni.lu)'
license    'GPL v3'
summary    'Configure and manage sudo and sudoers files'
description 'Configure and manage sudo and sudoers files'
project_page 'UNKNOWN'

## List of the classes defined in this module
classes    'sudo::params, sudo, sudo::common, sudo::debian, sudo::redhat'

## Add dependencies, if any:
# dependency 'username/name', '>= 1.2.0'
dependency 'concat'
defines    '["sudo::alias::command", "sudo::alias::user", "sudo::defaults::spec"]'
