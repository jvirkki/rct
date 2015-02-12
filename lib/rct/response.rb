#
#  Copyright 2012-2013 Jyri J. Virkki <jyri@virkki.com>
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
# The Response object represents the response from one HTTP call.
# This Response class wraps the response object from the underlying
# HTTP client library and provides assorted convenience methods.
#
# Client class methods will receive a Response object back from yield.
# Client class methods must return this Response object.
#
# Currently using response from HTTPClient:
# http://rubydoc.info/gems/httpclient/HTTP/Message
#
#
class Response


  #----------------------------------------------------------------------------
  # Constructor...
  #
  # The 'res' argument must never be nil for successful responses. It
  # may be nil if this represents an error response.
  #
  def initialize(res)
    @res = res
    @fail_msg = nil
  end


  #----------------------------------------------------------------------------
  # Flag this reponse as an error and add an error message string.
  # This method may be called multiple times, the error messages are
  # appended to each other.
  #
  def add_error(msg)
    if (@fail_msg == nil)
      @fail_msg = msg
    else
      @fail_msg = "#{@fail_msg}; #{msg}"
    end
  end


  #----------------------------------------------------------------------------
  # Returns true unless this response has been flagged as an error via
  # add_error() method.
  #
  def ok
    return true if @fail_msg == nil
    return false
  end


  #----------------------------------------------------------------------------
  # Return HTTP status code (or -1 if an error)
  #
  def status
    return -1 if @res == nil
    return @res.status
  end


  #----------------------------------------------------------------------------
  # Return requested HTTP header (or nil if an error)
  #
  def header(name)
    return nil if @res == nil
    return @res.header[name]
  end


  #----------------------------------------------------------------------------
  # Return all HTTP headers (or nil if an error)
  #
  def headers
    return nil if @res == nil
    return @res.headers
  end


  #----------------------------------------------------------------------------
  # Return HTTP response body (or nil if an error)
  #
  def body
    return nil if @res == nil
    return @res.content
  end


  #----------------------------------------------------------------------------
  # Return short string representation. On error, contains the error
  # message(s). Otherwise, contains the HTTP response code and text
  # description.
  #
  def to_s
    return "error: #{@fail_msg}" if @res == nil

    rv = "#{@res.status} #{@res.reason}"
    if (@fail_msg != nil)
      rv += " (#{@fail_msg})"
    end
    return rv
  end


end
