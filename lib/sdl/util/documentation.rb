require 'active_support/inflector'

I18n.config.enforce_available_locales = true

module I18n
  class MissingTranslation
    module Base
      alias :old_message :message unless method_defined?(:old_message)

      def message
        puts old_message

        I18n.backend.store_translations I18n.locale, to_deep_hash({@key => 'Translate'})

        old_message
      end

      # Taken from: http://www.ruby-doc.org/gems/docs/t/translate-rails3-0.2.2/Translate/Keys.html
      def to_deep_hash(hash)
        hash.inject({}) do |deep_hash, (key, value)|
          keys = key.to_s.split('.').reverse
          leaf_key = keys.shift
          key_hash = keys.inject({leaf_key.to_sym => value}) { |hash, key| {key.to_sym => hash} }
          deep_hash.deep_merge!(key_hash)
          deep_hash
        end
      end
    end
  end
end

module SDL
  module Util
    module Documentation
      def self.included(base)
        base.extend(self)
      end

      def documentation
        if self.respond_to?(:documentation_key)
          documentation = I18n.t(documentation_key)

          if documentation =~ /#\{.*\}/
            eval '"' + I18n.t(documentation_key) + '"', binding
          else
            documentation
          end
        end
      end

      def self.walk_the_class_name(klass)
        klass_key = klass.local_name.underscore.downcase

        if klass.superclass.eql?(SDL::Base::Type)
          klass_key = "#{klass.superclass.local_name.underscore.downcase}.#{klass_key}"
        else
          klass_key = "#{walk_the_class_name(klass.superclass)}_#{klass_key}"
        end

        klass_key
      end
    end
  end

  module Base
    [Type, Property].each do |m| m.class_eval do include SDL::Util::Documentation end end
  end
end

module SDL::Base
  class Type
    def self.documentation_key
      "sdl.#{SDL::Util::Documentation.walk_the_class_name(self)}"
    end

    def documentation_key
      "sdl.instance.#{SDL::Util::Documentation.walk_the_class_name(self.class)}.#{@identifier}"
    end
  end

  class Property
    ##
    # As properties are inherited, the documentation could either be defined by the current type, or any subtypes, which
    # also define or inherit this key. This method finds the first defined key.
    def documentation_key
      # Search class and ancestors, if any defines a documentation key
      @holder.ancestors.each do |ancestor|
        break if ancestor.eql?(SDL::Base::Type) || ancestor.eql?(SDL::Types::SDLType)

        key = "sdl.property.#{SDL::Util::Documentation.walk_the_class_name(ancestor)}.#{@name}"

        return key if I18n.exists? key
      end

      # Return default key
      return "sdl.property.#{SDL::Util::Documentation.walk_the_class_name(@parent)}.#{@name}"
    end
  end
end