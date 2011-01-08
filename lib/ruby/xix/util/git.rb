# encoding: utf-8

require 'xix/util/core_ext'

begin; gem 'grit'; rescue LoadError; end
autoload :Grit, 'grit'

begin; gem 'inifile'; rescue LoadError; end
autoload :IniFile, 'inifile'

begin; gem 'octopussy'; rescue LoadError; end
autoload :Octopussy, 'octopussy'

# TODO config_map argümanları, nonnative'i devnullsız yap

module Xix
  module Util
    module Git 
      CONFIG_MAP = {
        'github' => {
          "user"  => :login,
          "token" => :token,
        },
        'user' => {
          'name'  => :fullname,
          'email' => :email,
        },
      }

      class << self
        def config(config_map=CONFIG_MAP)
          @@config
        rescue NameError
          @@config =
            begin
              init_config_native
            rescue
              begin
                init_config_nonnative
              rescue
                {}
              end
            end
        end

        def ensure_configured(config_map=CONFIG_MAP, &block)
          lookup = config_map_lookup config_map 
          missing = lookup.reject { |key, target| config[target] }.keys
          block_given? ? yield(missing, config) : exit_missing(missing)
        end

        def exit_missing(missing)
          unless missing.empty?
            $stderr.puts 'Git ayarlarında bazı alanlar eksik.  Lütfen aşağıdaki komutlarla ayarlayın ve tekrar deneyin:'
            missing.each { |k| $stderr.puts "  git config --global #{k} <DEĞER>" }
            exit 1
          end
        end

        private

          def config_map_lookup(config_map)
            Hash[
              *config_map.map do |section, field|
                field.map { |key, target| [ "#{section}.#{key}", target ] }
              end.flatten
            ]
          end

          def init_config_native(config_map=CONFIG_MAP)
            ini = IniFile.new ENV['HOME'] + '/.gitconfig', :parameter => '='
            Hash[
              *config_map.map do |section, field|
                ini[section].map do |key, value|
                  [ field[key], value ]
                end
              end.flatten
            ]
          end

          def init_config_nonnative(config_map=CONFIG_MAP)
            lookup = config_map_lookup config_map
            Hash[
              *%x(git config --global --get-regexp '^(#{config_map.keys.join("|")})\\b' 2>/dev/null)
                .split(/\n+/)
                .compact
                .map { |s|
                  key, value = s.split(/\s+/, 2)
                  [ lookup.fetch(key, key), value ]
                }.flatten
            ]
          end

      end
    end

    # Simplistic helpers for Github scripting.  Please use a full blown gem
    # for complex scenarios.

    module Github
      FMT_URL = {
        :http => 'https://github.com/%s/%s',
        :git  => 'git://github.com/%s/%s',
        :ssh  => 'git@github.com:%s/%s',
      }

      FMT_FILE = '/raw/%s/%s'

      def uri(*args)
        if args.size % 2 == 0
          option = Hash[*args]
        else
          option = Hash[*args]
          option[:repo] = repo
        end

        config = Git.config

        account = option.fetch(:account, config[:login])
        repo    = option[:repo]
        file    = option[:file]
        branch  = option.fetch(:branch, 'master')

        scheme  = option.fetch(:scheme, :http).to_sym
        unless file.nil? || file.empty?
          scheme = :http
        end

        url = FMT_URL[scheme] % [account, repo]
        unless file.nil? || file.empty?
          url + FMT_FILE % [branch, file]
        end

        url
      end
    end
  end
end

module Octopussy
  class Client
    def self.authorized(*args)
      args.unshift Xix::Util::Git.config if args.size == 0
      self.new *args
    end
  end
end
