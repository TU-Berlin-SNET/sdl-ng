class SDL::Base::ServiceCompendium
  # A transaction for loading vocabulary definition
  module VocabularyLoadTransaction
    include LoadTransaction

    ##
    # Loads vocabulary, either from a file or from a path recursively.
    #
    # Vocabulary definition files are expected to end with +.sdl.rb+
    # @param path_or_filename[String] Either a filename or a path
    def load_vocabulary_from_path(path_or_filename)
      to_files_array(path_or_filename, '.sdl.rb').each do |filename|
        with_uri filename do
          load_vocabulary_from_string File.read(filename), filename
        end
      end
    end

    ##
    # Loads a vocabulary from a string. The URI is used with ServiceCompendium#with_uri.
    # @param [String] vocabulary_definition The vocabulary definition
    # @param [String] uri The URI
    def load_vocabulary_from_string(vocabulary_definition, uri)
      begin
        with_uri uri do
          eval vocabulary_definition, binding
        end
      rescue Exception => e
        unload uri

        raise "Error while loading vocabulary from #{uri}: #{e}"
      end
    end
  end
end