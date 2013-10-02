module SDL
  module Receivers
    class TypeReceiver
      include ActiveSupport::Inflector

      attr :klass
      attr :subclasses
      attr :compendium

      def initialize(sym, compendium, superclass = nil)
        @compendium = compendium
        @klass = Class.new(superclass || base_class)
        @klass.local_name = sym.to_s.camelize

        @subclasses = [@klass]

        register_sdltype(@klass)
      end

      def base_class
        SDL::Base::Type
      end

      def register_sdltype(klass)
        klass.class_eval do
          include SDL::Types::SDLType

          wraps self
          codes local_name.underscore.to_sym
        end
      end

      def subtype(sym, &definition)
        receiver = self.class.new(sym, @compendium, @klass)
        receiver.instance_eval(&definition) if block_given?

        @subclasses.concat(receiver.subclasses)
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
            @klass.class_eval do
              attr_accessor sym
            end
          else
            # Define accessor method for lists
            @klass.class_eval do
              define_method sym do
                eval "@#{sym} ||= []"
              end
            end
          end

          @klass.properties << SDL::Base::Property.new(sym, type, multi)
        end
    end
  end
end