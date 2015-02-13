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


# http://guides.rubygems.org/specification-reference/

Gem::Specification.new do |s|

  version_line = `cat lib/rct/constants.rb | grep RCT_VERSION`
  version_line =~ /RCT_VERSION = '(.*)'/
  version = $1

  lib_files = `find lib -type f`

  s.name = 'rct'
  s.version = version
  s.executables << 'rct'
  s.summary = 'rct'
  s.description = 'wip'
  s.authors = ["Jyri J. Virkki"]
  s.email = 'jyri@virkki.com'
  s.homepage = 'https://github.com/jvirkki/rct'
  s.files = lib_files.split
  s.rubyforge_project = "nowarning"
  s.license = 'GPLv3'
  s.add_runtime_dependency 'httpclient'
end
