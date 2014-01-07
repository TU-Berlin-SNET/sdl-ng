#:include: ../README.md

require 'active_support'
require 'active_support/dependencies'
require 'active_support/inflector'

require 'i18n'

ActiveSupport::Dependencies.autoload_paths += ['sdl']

##
#
# Author::  Mathias Slawik (mailto:mathias.slawik@tu-berlin.de)
# License:: Apache License 2.0
module SDL
  extend ActiveSupport::Autoload

  autoload :Base
  autoload :Exporters
  autoload :Receivers

  eager_autoload do
    autoload :Types
  end

  require_relative 'sdl/util'
  require_relative 'sdl/ng/version'
end