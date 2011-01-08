# encoding: utf-8
require 'x'

require_all_available "xix/util"

require 'pathname'

require 'fileutils'
include FileUtils

Signal.trap("INT") { puts; exit }

class Thor;        include Thor::Actions; end
class Thor::Group; include Thor::Actions; end
