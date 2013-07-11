 require 'mongoid'
 module Mongoid #:nodoc:
  module MagicCounterCache
    extend ActiveSupport::Concern

    module ClassMethods

      def counter_cache(*args, &block)
        options = args.extract_options!
        name    = options[:class] || args.first.to_s

        if options[:field]
          counter_name = "#{options[:field].to_s}"
        else
          counter_name = "#{model_name.demodulize.underscore}_count"
        end
        after_create  do |doc|
          if doc.embedded?
            parent = doc._parent
            parent.inc(counter_name.to_sym, 1) if parent.respond_to? counter_name
          else
            relation = doc.send(name)
            if relation && relation.class.fields.keys.include?(counter_name)
              relation.inc(counter_name.to_sym,  1)
            end
          end
        end

        after_destroy do |doc|
          if doc.embedded?
            parent = doc._parent
            parent.inc(counter_name.to_sym, -1) if parent.respond_to? counter_name
          else
            relation = doc.send(name)
            if relation && relation.class.fields.keys.include?(counter_name)
              relation.inc(counter_name.to_sym, -1)
            end
          end
        end

      end

      alias :magic_counter_cache :counter_cache
    end

  end
end