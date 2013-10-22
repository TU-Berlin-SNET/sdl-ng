require 'active_support/inflector'

module I18n
  class MissingTranslation
    module Base
      alias :old_message :message

      def message
        puts old_message

        I18n

        old_message
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
          I18n.t(documentation_key)
        end
      end

      def self.walk_the_class_name(klass)
        klass_key = klass.local_name.underscore.downcase

        unless klass.eql?(SDL::Base::Fact) || klass.eql?(SDL::Base::Type)
          klass_key = "#{walk_the_class_name(klass.superclass)}.#{klass_key}"
        end

        klass_key
      end

      [SDL::Base::Type, SDL::Base::Fact, SDL::Base::Property].each do |m| m.class_eval do include SDL::Util::Documentation end end
    end
  end
end

module SDL
  module Base
    class Type
      def self.documentation_key
        "sdl.#{SDL::Util::Documentation.walk_the_class_name(self)}"
      end
    end

    class Property
      def documentation_key
        "sdl.#{SDL::Util::Documentation.walk_the_class_name(@parent)}.#{@name}"
      end
    end
  end
end