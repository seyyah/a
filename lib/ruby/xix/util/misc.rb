# encoding: utf-8

require 'yaml'
require 'open-uri'

module Xix
  module Util
    module_function
  end
end

module YAML
  def self.fetch(uri)
      open(uri) { |f| YAML::load(f) }
  end
end
