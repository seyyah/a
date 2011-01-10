# encoding: utf-8
Dir[File.join(ENV['XIX_ETC'], 'irb', "*.rb")].sort.each do |file|
  begin; require file; rescue LoadError; end
end
