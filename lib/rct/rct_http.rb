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


require 'httpclient'


#------------------------------------------------------------------------------
# This class provides the HTTP connection support for rct. This serves
# to hide the details of the underlying HTTP connector class so that
# it can be changed conveniently if desired.
#
# Currently using HTTPClient:
# http://rubydoc.info/gems/httpclient/2.1.5.2/HTTPClient
#
class RCTHTTP


  #----------------------------------------------------------------------------
  # Constructor.
  #
  def initialize
    @http_client = HTTPClient.new()
  end


  #----------------------------------------------------------------------------
  # Handle one HTTP request.
  #
  # Connection parameters are all obtained from the current state (see
  # constants.rb). Destination server is specified by type (SERVER_TYPE)
  # OR by hostname+port. If both are given, type takes precedence.
  #
  # * SERVER_TYPE     - Connect to a server of this type.
  # * SERVER_HOSTNAME - Connect to this server.
  # * SERVER_PORT     - Connect to this port on server.
  # * SERVER_PROTOCOL - Protocol (http/https).
  # * REQ_PATH        - Request path.
  # * REQ_PARAMS      - If set, appended to request path.
  # * REQ_METHOD      - HTTP method to use (if not set, default is GET)
  # * REQ_HEADERS     - Optional hash of additional request headers to set.
  # * REQ_BODY        - Optional request body.
  #
  # Always returns an rct Response object.
  #
  def handle_request

    if (RCT.sget(SERVER_TYPE) != nil)
      die("request by server type not implemented!")
    end

    protocol = RCT.sget(SERVER_PROTOCOL)
    host = RCT.sget(SERVER_HOSTNAME)

    if (protocol == nil)
      die("server protocol missing!")
    end

    if (host == nil)
      die("server hostname missing!")
    end

    url = "#{protocol}://#{host}"
    port = RCT.sget(SERVER_PORT)
    if (port != nil)
      url += ":#{port}"
    end
    url += RCT.sget(REQ_PATH)

    params = RCT.sget(REQ_PARAMS)
    if (params != nil && !params.empty?)
      url += params
    end

    method = RCT.sget(REQ_METHOD)
    if (method == nil || method.empty?)
      method = "GET"
    end

    headers = RCT.sget(REQ_HEADERS)
    if (headers == nil)
      headers = Hash.new()
    end
    headers['User-agent'] = "rct/#{RCT_VERSION}"

    auth = RCT.sget(REQ_AUTH_TYPE)
    if (auth != nil)
      if (auth == REQ_AUTH_TYPE_BASIC)
        name = RCT.sget(REQ_AUTH_NAME)
        pwd = RCT.sget(REQ_AUTH_PWD)
        @http_client.set_auth(nil, name, pwd)
      else
        raise "Requested auth type '#{auth}' unknown"
      end
    end

    show_request(method, url, headers, RCT.sget(REQ_BODY))

    res = nil
    begin
      if (method == "GET")
        res = @http_client.get(url, nil, headers)

      elsif (method == "POST")
        body = RCT.sget(REQ_BODY)
        res = @http_client.post(url, body, headers)

      elsif (method == "PUT")
        body = RCT.sget(REQ_BODY)
        res = @http_client.put(url, body, headers)

      elsif (method == "DELETE")
        res = @http_client.delete(url, headers)

      else
        raise "Method #{method} not implemented yet!"
      end

    rescue Exception => e
      response = Response.new(nil)
      response.add_error(e.to_s)
      show_response(response)
      return response
    end

    show_response(res)
    response = Response.new(res)
    return response
  end


  #----------------------------------------------------------------------------
  # Show verbose info about the request.
  #
  def show_request(method, url, headers, body)
    return if (RCT.log_level < INFO)

    RCT.log(INFO, "-----[ REQUEST ]---" + "-" * 60)
    RCT.log(INFO, "#{method} #{url}")
    headers.each { |k,v|
      RCT.log(INFO, "#{k}: #{v}")
    }
    RCT.log(INFO, "")

    if (body != nil)
      RCT.log(INFO, body)
      RCT.log(INFO, "")
    end
  end


  #----------------------------------------------------------------------------
  # Show verbose info about the response.
  #
  def show_response(res)
    return if (RCT.log_level < INFO)

    RCT.log(INFO, "-----[ RESPONSE ]--" + "-" * 60)
    RCT.log(INFO, "#{res.to_s}")

    headers = res.headers
    if (headers != nil)
      headers.each { |k,v|
        RCT.log(INFO, "XH: #{k}: #{v}")
      }
    end

    RCT.log(INFO, res.body)
  end

end
