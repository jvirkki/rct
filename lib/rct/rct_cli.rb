#
#  Copyright 2012-2016 Jyri J. Virkki <jyri@virkki.com>
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
# Client methods can provide friendly output in CLI mode by setting
# CLI_OUTPUT to the desired text. If it is not set, the raw response body
# is shown.
#
class RCTCLI


  #----------------------------------------------------------------------------
  # CLI entry point.
  #
  # ARGV[0] must contain string "Class.operation". We'll instantiate 'Class'
  # and execute CLI operation 'operation'. This operation must be one described
  # by the 'cli' inspection method.
  #
  # The exception is if 'operation' is 'HELP', in which case auto-generated
  # help output is shown.
  #
  def self.rct_cli
    method = ARGV.shift
    if (method == nil || method.empty?)
      RCT.bad_invocation("no CLI class/method given!")
    end

    method =~ /([^\.]*)\.(.*)/
    class_name = $1
    method_name = $2
    RCT.log(DEBUG, "Requested [#{method}]")
    RCT.log(DEBUG, "CLI class: #{class_name}, method: #{method_name}")

    if (!class_name)
      RCT.error("No class specified for CLI operation")
      exit(1)
    end

    if (!method_name)
      RCT.error("No method specified for CLI operation")
      exit(1)
    end

    obj = Object::const_get(class_name).new()
    begin
      cli_info = obj.send('cli')
    rescue Exception => e
      puts e
      RCT.error("#{class_name} does not support CLI operations")
      exit(1)
    end

    if (method_name == "HELP")
      description = obj.send('description')
      show_help(description, cli_info)
    end

    method_info = cli_info[method_name]
    if (method_info == nil)
      RCT.error("#{class_name}.#{method_name} not available")
      exit(1)
    end

    RCT.parse_options(method_info['required'], true)
    RCT.parse_options(method_info['optional'], false)

    response = obj.send(method_name) {
      $HTTP.handle_request()
    }

    if response == nil
      RCT.log(INFO, "warning: response nil, likely a bug in " +
              "#{class_name}.#{method_name}?")
    end

    RCT.log(INFO, response)
    cli_output = RCT.sget(CLI_OUTPUT)
    if (cli_output != nil)
      puts cli_output
    else
      puts response
      puts response.body
    end
  end


  #----------------------------------------------------------------------------
  # Show autogenerated help based on cli_info
  #
  def self.show_help(description, cli_info)

    puts
    if (description != nil)
      puts description
      puts
    end

    cli_info.each_key { |key|

      method_info = cli_info[key]
      description = method_info['description']
      req = method_info['required']
      opt = method_info['optional']

      puts
      puts "#{key}: #{description}"

      if (req != nil && req.length > 0)
        puts "  Required arguments:"
        req.each { |key,arg|
          puts "    #{arg[0]} (#{arg[1]})  : #{arg[2]}"
        }
      end

      if (opt != nil && opt.length > 0)
        puts "  Optional arguments:"
        opt.each { |key,arg|
          puts "    #{arg[0]} (#{arg[1]})  : #{arg[2]}"
        }
      end
    }

    exit(0)
  end


end
