# encoding: utf-8
# ------------------------------------------------------------------------------
# Core utils
# ------------------------------------------------------------------------------
require 'xix/util/base'
require 'xix/util/core_ext'

# ------------------------------------------------------------------------------
# Extra core utils
# ------------------------------------------------------------------------------
def require_all(dir)
  $:.map  { |path| File.join(path, "#{dir}/*.rb") }
    .map  { |glob| Dir[glob] }.flatten
    .each { |file| require file }
end
def require_all_available(dir)
  $:.map  { |path| File.join(path, "#{dir}/*.rb") }
    .map  { |glob| Dir[glob] }.flatten
    .each { |file| begin; require file; rescue LoadError; end }
end
