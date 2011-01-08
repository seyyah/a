# encoding: utf-8

require 'xix/util'

if defined? X
  raise LoadError, "X already defined" unless  X == Xix::Util
else
  X = Xix::Util
end
