require 'active_support/inflector'

module SDL
  module Receivers
    module PropertyDefinitions
      def self.included(base)
        base.class_eval do
          def self.define_properties_for(sym)
            @target_class = sym
          end
        end
      end

      ##
      # Define a list of a type, which is defined in the block.
      def list(name, &block)
        list_type = @compendium.type name.to_s.singularize.to_sym, &block

        add_property name.to_sym, list_type, true
      end

      def method_missing(name, *args, &block)
        sym = args[0]

        if name =~ /list_of_/
          multi = true
          type = @compendium.sdltype_codes[name.to_s.gsub('list_of_', '').singularize.to_sym]
        else
          multi = false
          type = @compendium.sdltype_codes[name.to_sym]
        end

        if type
          add_property sym, type, multi
        else
          super(name, *args, &block)
        end
      end

      private
        ##
        # Adds accessors to set the property to the target class.
        def add_property(sym, type, multi)
          unless multi
            target_class.class_eval do
              attr_accessor sym
            end
          else
            # Define accessor method for lists
            target_class.class_eval do
              define_method sym do
                eval "@#{sym} ||= []"
              end
            end
          end

          target_class.properties << SDL::Base::Property.new(sym, type, multi)
        end

        def target_class
          send self.class.instance_variable_get('@target_class')
        end
    end
  end
end