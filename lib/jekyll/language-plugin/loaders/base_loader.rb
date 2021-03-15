# Frozen-string-literal: true
# Encoding: utf-8

module Jekyll
  module LanguagePlugin
    module Loaders
      class BaseLoader
        attr_reader :site

        def initialize(site)
          @site = site
          @is_loaded = false
        end

        def loaded?(language)
          true
        end

        def load(language)
          true
        end

        def get(key, language)
          nil
        end

        def get_with_placeholders(key, tokens, language)
          res = get(key, language)
          return nil if res.nil?
          res.gsub(/%%/).with_index { |m, i| tokens[i] || m }
        end

        def traverse_hash(hash, keys)
          for key in keys
            return hash unless hash.is_a?(Hash)
            return nil unless hash.key?(key)
            hash = hash[key]
          end
          if hash.is_a?(Hash)
            hash.sort_by {|k,v|k == 'slug' ? 0 : 1}.to_h
          else
            hash
          end
        end

        def resolve_dot_notation(keys)
          return keys.split('.') if keys.is_a?(String)
          return [] if !keys.is_a?(Enumerable)

          keys.flat_map do |key|
            resolve_dot_notation(key)
          end
        end
      end
    end
  end
end
