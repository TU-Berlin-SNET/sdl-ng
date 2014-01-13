#:include: ../README.md

require 'active_support'
require 'active_support/dependencies'
require 'active_support/inflector'

require 'i18n'
require 'verbs'

##
#
# Author::  Mathias Slawik (mailto:mathias.slawik@tu-berlin.de)
# License:: Apache License 2.0
module SDL
  extend ActiveSupport::Autoload

  autoload :Base
  autoload :Exporters
  autoload :Receivers
  autoload :Types
  autoload :NG, File.join(__dir__, 'sdl', 'ng', 'version.rb')

  ActiveSupport::Dependencies::Loadable.require_dependency File.join(__dir__, 'sdl', 'util.rb')
end