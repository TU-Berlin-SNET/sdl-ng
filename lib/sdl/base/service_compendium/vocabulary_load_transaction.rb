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
          load_vocabulary_from_string File.read(filename), filename, filename
        end
      end
    end

    ##
    # Loads a vocabulary from a string. The URI is used with ServiceCompendium#with_uri.
    # @param [String] vocabulary_definition The vocabulary definition
    # @param [String] uri The URI
    # @param [String] filename An optional filename
    def load_vocabulary_from_string(vocabulary_definition, uri, filename = nil)
      begin
        with_uri uri do
          self.instance_eval vocabulary_definition, filename, 1
        end
      rescue Exception => e
        unload uri

        raise RuntimeError, "Error while loading vocabulary from #{uri}: #{e}", (e.backtrace.concat(caller))
      end
    end
  end
end