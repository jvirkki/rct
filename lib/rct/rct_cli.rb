#
#  Copyright 2012 Jyri J. Virkki <jyri@virkki.com>
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


#------------------------------------------------------------------------------
# Provides access to rct client methods as a CLI.
#
# In order to be accessible via CLI, a client class must implement a
# 'cli' method which provides info about the CLI methods and their
# arguments.
#
class RCTCLI


  def self.rct_cli
    method = $ARGV.shift
    if (method == nil || method.empty?)
      RCT.bad_invocation("no CLI class/method given!")
    end

    method =~ /([^\.]*)\.(.*)/
    class_name = $1
    method_name = $2
    RCT.log(DEBUG, "CLI class: #{class_name}, method: #{method_name}")

    obj = Object::const_get(class_name).new()
    begin
      cli_info = obj.send('cli')
    rescue Exception => e
      puts e
      error("#{class_name} does not support CLI operations")
      exit(1)
    end

    method_info = cli_info[method_name]
    if (method_info == nil)
      error("#{class_name}.#{method_name} not available")
      exit(1)
    end

    RCT.parse_options(method_info['required'], true)
    RCT.parse_options(method_info['optional'], false)

    response = obj.send(method_name) {
      $HTTP.handle_request()
    }

    RCT.log(INFO, response)
    puts response.body
  end


end
