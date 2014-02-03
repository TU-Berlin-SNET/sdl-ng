module SDL::Base::ServiceCompendium::LoadTransaction
  def to_files_array(path_or_filename, suffix)
    if File.file? path_or_filename
      [path_or_filename]
    elsif File.directory? path_or_filename
      Dir.glob(File.join(path_or_filename, '**', "*#{suffix}"))
    end
  end
end