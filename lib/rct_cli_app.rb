#
#  Copyright 2013-2015 Jyri J. Virkki <jyri@virkki.com>
#
#  This file is part of rct.
#
#  rct is free software: you can redistribute it and/or modify it
#  under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  rct is distributed in the hope that it will be useful, but
#  WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with rct.  If not, see <http://www.gnu.org/licenses/>.
#


#-----------------------------------------------------------------------------
# CLI scripts built on top of rct can require this file to initialize rct.
#
# The common use case for this is when implementing convenience
# scripts to call the CLI functionality of an rct module (which
# supports CLI operation). For an example see 'jira' script installed
# by rct_jira gem.
#
# If global $RCT_CLI_APP_CLASS has been set, it is used as the CLI
# class name to run. This allows convenience script to set their class
# name so the user can provide only the CLI operation name. If not
# set, ARGV from caller is not modified. See below.
#


require 'rct'
require 'rct/rct_init'


if ($RCT_CLI_APP_CLASS != nil)
  if (ARGV.length == 0)
    ARGV.insert(0, "#{$RCT_CLI_APP_CLASS}.HELP")
  else
    method = ARGV.shift
    ARGV.insert(0, "#{$RCT_CLI_APP_CLASS}.#{method}")
  end
end

RCT.parse_global_options()
RCTCLI.rct_cli()
