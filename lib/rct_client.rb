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


require 'securerandom'
require 'json'
require 'cgi'


#------------------------------------------------------------------------------
# Base class for rct client classes.
#
class RCTClient


  #----------------------------------------------------------------------------
  # Adds an additional query param "name=value" to the given 'params'.
  # This 'params' may be nil.
  #
  # The new param is added only if both name and value are non-nil,
  # otherwise params is returned unchanged.
  #
  def add_param(params, name, value)
    if (name == nil || name.empty? || value == nil || value.empty?)
      return params
    end

    val = CGI.escape(value)
    if (params == nil || params.empty?)
      return "?#{name}=#{val}"
    end

    return "#{params}&#{name}=#{val}"
  end


  #----------------------------------------------------------------------------
  # Returns a random UUID.
  #
  def uuid
    return SecureRandom.uuid()
  end


  #----------------------------------------------------------------------------
  # Return true if var contains something (that is, it is not nil and
  # not empty).
  #
  def set(var)
    return false if var == nil
    return false if var.empty?
    return true
  end


  #----------------------------------------------------------------------------
  # If the global state contains a non-nil/non-empty value for key
  # 'name', add it to the 'hash' provided.
  #
  def add_to_hash_if_set(name, hash)
    value = RCT.sget(name)
    return false if value == nil
    return false if value.empty?
    hash[name] = value
    return true
  end


  #----------------------------------------------------------------------------
  # Log a message. Level is one of RESULT, INFO, DEBUG.
  #
  def log(level, line)
    rct_log(level, line)
  end


  #----------------------------------------------------------------------------
  # Set (or change) 'key' in state to contain 'value'.
  # If 'temp' is true, this key is stored in temporary state only.
  #
  def sset(key, value, temp=false)
    RCT.sset(key, value, temp)
  end


  #----------------------------------------------------------------------------
  # Set (or change) 'key' in temporary state to contain 'value'.
  #
  def ssettmp(key, value)
    RCT.sset(key, value, true)
  end


  #----------------------------------------------------------------------------
  # Get the value of 'key' (if available, or returns nil).
  #
  def sget(key)
    RCT.sget(key)
  end


  #----------------------------------------------------------------------------
  # Get the value of 'key' (if available, or default).
  #
  def sgetdef(key, default)
    RCT.sgetdef(key, default)
  end


  #----------------------------------------------------------------------------
  # Delete the given 'key' from both permanent and temporary state.
  #
  def sdelete(key)
    RCT.sdelete(key)
  end


  #----------------------------------------------------------------------------
  # Convenience function, returns true if we're running in CLI mode.
  #
  def is_cli
    mode = sget(RCT_MODE)
    return true if (mode == RCT_MODE_CLI)
    false
  end


  #----------------------------------------------------------------------------
  # Convenience function, set CLI output only if we're running in CLI mode.
  #
  def cli_out(line)
    if (is_cli)
      sset(CLI_OUTPUT, line)
      true
    end
    false
  end


end
