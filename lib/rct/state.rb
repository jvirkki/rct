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
# This is the global state where mostly everything is kept in rct.
#
# There are two kinds of state, permanent and temporary. Values set in
# temporary state can be removed with the reset() method. Values in
# permanent state remain available for the lifetime of this State
# object (unless individually removed with delete() method).
#
# When retrieving a value, content in the temporary state overrides
# content in permanent state if the key is present in both. This
# provides a way to temporarily override a global default.
#
class State


  #----------------------------------------------------------------------------
  # Constructor...
  #
  def initialize
    @h = Hash.new()
    @tmp = Hash.new()
  end


  #----------------------------------------------------------------------------
  # Set (or change) 'key' in state to contain 'value'.
  # If 'temp' is true, this key is stored in temporary state only.
  #
  def set(key, value, temp=false)
    if (temp)
      @tmp[key] = value
    else
      @h[key] = value
    end
  end


  #----------------------------------------------------------------------------
  # Get the value of 'key' (if available, or returns nil).
  #
  def get(key)
    if (@tmp[key] != nil)
      return @tmp[key]
    else
      return @h[key]
    end
  end


  #----------------------------------------------------------------------------
  # Delete the given 'key' from both permanent and temporary state.
  #
  def delete(key)
    @h.delete(key)
    @tmp.delete(key)
  end


  #----------------------------------------------------------------------------
  # Reset temporary state.
  # Returns the old temporary state hash object.
  #
  def reset
    tmp = @tmp
    @tmp = Hash.new
    return tmp
  end


end
