ActiveSupport::Dependencies.load_file File.join(__dir__, 'util', 'nokogiri.rb')
ActiveSupport::Dependencies.load_file File.join(__dir__, 'util', 'documentation.rb')
ActiveSupport::Dependencies.load_file File.join(__dir__, 'util', 'verbs.rb')

I18n.load_path << File.join(__dir__, 'translations', 'en.yml')