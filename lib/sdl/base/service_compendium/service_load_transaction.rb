# A transaction for loading vocabulary definition
module SDL::Base::ServiceCompendium::ServiceLoadTransaction
  ##
  # Loads a service, either from a file or from a path recursively.
  #
  # Service definition files are expected to end with +.service.rb+
  # @param path_or_filename[String] Either a filename or a path
  def load_service_from_path(path_or_filename)
    path_or_filename = [path_or_filename] if File.file? path_or_filename

    Dir.glob(File.join(path_or_filename, '**', '*.service.rb')) do |filename|
      service_name = filename.match(%r[.+/(.+).service.rb])[1]

      load_service_from_string File.read(filename), service_name, filename
    end
  end

  ##
  # Loads a service from a string. The URI is used with ServiceCompendium#with_uri.
  # @param [String] service_definition The service definition
  # @param [String] service_name The service name
  # @param [String] uri The URI
  # @raise [SyntaxError] If there is an error in service_definition
  def load_service_from_string(service_definition, service_name, uri)
    begin
      with_uri uri do
        service service_name do
          eval service_definition, binding
        end
      end
    rescue Exception => e
      raise SyntaxError.new("Error while loading '#{service_name}' from '#{uri}': #{e}")
    end
  end
end