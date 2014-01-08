module SDL
  module Receivers
    extend ActiveSupport::Autoload

    autoload :Receiver
    autoload :FactReceiver
    autoload :ServiceReceiver
    autoload :TypeReceiver
    autoload :TypeInstanceReceiver
  end
end