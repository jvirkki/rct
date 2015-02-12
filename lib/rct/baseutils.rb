#
#  Copyright 2012-2015 Jyri J. Virkki <jyri@virkki.com>
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
# Assorted utility methods of general interest.
#
class RCT

  @log_level = RESULT


  #---------------------------------------------------------------------------
  # Return current log level.
  #
  def self.log_level
    @log_level
  end


  #---------------------------------------------------------------------------
  # Set log level (RESULT, INFO, DEBUG; from constants.rb).
  #
  def self.set_log_level(level)
    @log_level = RESULT if level == RESULT
    @log_level = INFO if level == INFO
    @log_level = DEBUG if level == DEBUG
  end


  #---------------------------------------------------------------------------
  # Increase log verbosity level by one.
  #
  def self.increase_log_level
    @log_level += 1
  end


  #---------------------------------------------------------------------------
  # Log a line of output, if appropriate for current log level.
  #
  def self.log(level, line)
    if (level <= @log_level)
      puts line
    end
  end


  #---------------------------------------------------------------------------
  # Log an error to stdout (prefixed with 'error:')
  #
  def self.error(msg)
    puts "error: #{msg}"
  end


  #---------------------------------------------------------------------------
  # Log an error to stdout (prefixed with 'error:') and exit.
  #
  def self.bad_invocation(msg)
    error(msg)
    exit(1)
  end


  #---------------------------------------------------------------------------
  # Log an error to stdout (prefixed with 'error:') and exit.
  #
  def self.die(msg)
    error(msg)
    exit(1)
  end


  #---------------------------------------------------------------------------
  # Return the value of the flag at position pos in ARGV.
  # Removes both the value and the flag from ARGV.
  #
  def self.argv_get(pos)
    value = ARGV[pos + 1]
    ARGV.delete_at(pos + 1)
    ARGV.delete_at(pos)
    return value
  end


  #---------------------------------------------------------------------------
  #
  #
  def self.help

    # default is CLI invocation of method name
    # rct Time.get_time
    #
    # provide require file if it is not in CLI list
    # rct Time.get_time --req time_client
    # rct --test test-suite

  end


  # define global options (from parse_global_options) so can do error chacking
  $GLOBAL_OPTS = {
    '-t' => 1, '--test' => 1, '--req' => 1, '-h' => 1, '--host' => 1,
    '-p' => 1, '--port' => 1, '-v' => 1, '--cafile' => 1
  }

  def self.parse_global_options
    pos = 0

    if (ARGV == nil)
      die("No arguments!")
    end

    while (pos < ARGV.length)
      arg = ARGV[pos]

      if (arg == '-t' || arg == '--test')
        sset(RCT_MODE, RCT_MODE_TEST)
        sset(TEST_SUITE_FILE, argv_get(pos))

      elsif (arg == '--req')
        require argv_get(pos)

      elsif (arg == '-h' || arg == '--host')
        sset(SERVER_HOSTNAME, argv_get(pos))

      elsif (arg == '-p' || arg == '--port')
        sset(SERVER_PORT, argv_get(pos))

      elsif (arg == '--cafile')
        sset(SSL_CA_FILE, argv_get(pos))

      elsif (arg == '-v')
        increase_log_level()
        ARGV.delete_at(pos)

      else
        pos += 1
      end

    end
  end


  def self.get_opt(info)
    pos = 0
    while (pos < ARGV.length)
      arg = ARGV[pos]
      if (arg == info[0] || arg == info[1])
        return argv_get(pos)
      else
        pos += 1
      end
    end
  end


  def self.parse_options(opts, required)
    return if opts == nil
    opts.each { |key, info|
      if ($GLOBAL_OPTS[info[0]] == 1 || $GLOBAL_OPTS[info[1]] == 1)
        bad_invocation("Error in CLI definition: #{info[0]}|#{info[1]} " +
                       "conflicts with global options!")
      end
      value = get_opt(info)
      if (required && value == nil)
        bad_invocation("Required argument #{info[0]}|#{info[1]} has no value!")
      end
      $STATE.set(key, value)
    }
  end


  #---------------------------------------------------------------------------
  # Set a key,value pair in the global state.
  #
  def self.sset(key, value, temp=false)
    $STATE.set(key, value, temp)
  end


  #---------------------------------------------------------------------------
  # Set a temporary key,value pair in the global state.
  #
  def self.ssettmp(key, value)
    $STATE.set(key, value, true)
  end


  #---------------------------------------------------------------------------
  # Get the value of a key from the global state.
  #
  def self.sget(key)
    $STATE.get(key)
  end


  #---------------------------------------------------------------------------
  # Remove the value of a key from the global state.
  #
  def self.sdelete(key)
    $STATE.delete(key)
  end


end
