class SDL::Base::ServiceCompendium
  # A transaction for loading vocabulary definition
  module ServiceLoadTransaction
    include LoadTransaction

    ##
    # Loads a service, either from a file or from a path recursively.
    #
    # Service definition files are expected to end with +.service.rb+
    # @param path_or_filename[String] Either a filename or a path
    # @param ignore_errors[Boolean] Ignore errors when loading service
    def load_service_from_path(path_or_filename, ignore_errors = false)
      to_files_array(path_or_filename, '.service.rb').each do |filename|
        service_name = filename.match(%r[.+/(.+).service.rb])[1]

        begin
          load_service_from_string File.read(filename), service_name, filename
        rescue Exception => e
          raise e unless ignore_errors
        end
      end
    end
  end

  ##
  # Loads a service from a string. The URI is used with ServiceCompendium#with_uri.
  # @param [String] service_definition The service definition
  # @param [String] service_name The service name
  # @param [String] uri The URI
  # @raise [SyntaxError] If there is an error in service_definition
  def load_service_from_string(service_definition, service_name, uri)
    with_uri uri do
      service service_name do
        eval service_definition, binding, uri
      end
    end
  end
end