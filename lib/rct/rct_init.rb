#
#  Copyright 2013 Jyri J. Virkki <jyri@virkki.com>
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


# A few globals:
$HTTP = RCTHTTP.new()
$STATE = State.new()

# Set some defaults:
RCT.sset(RCT_MODE, RCT_MODE_CLI)
RCT.sset(SERVER_PROTOCOL, 'http')
RCT.sset(SERVER_HOSTNAME, 'localhost')
RCT.sset(SERVER_PORT, '80')
