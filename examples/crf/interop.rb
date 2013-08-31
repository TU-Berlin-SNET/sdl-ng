require_relative '../../lib/service_compendium'

compendium = ServiceCompendium.new

compendium.facts_definition do
  namespace 'http://www.cloud-tresor.de/crf/flexibility/interoperatibility/interfacesandstandards'

  type :browser do
    string :min_version
  end

  type :browser_plugin

  fact :service_interface do
    better :more

    subfact :rest_interface
    subfact :soap_interface
    subfact :xmlrpc_interface

    subfact :browser_interface do
      list_of_browsers :compatible_browsers do
        better :more
      end

      list_of_browser_plugins :required_plugins do
        better :less
      end
    end
  end
end

puts compendium