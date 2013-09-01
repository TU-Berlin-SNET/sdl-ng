Dir.glob(File.join(__dir__, '*_receiver.rb')).each do |filename|
  require filename
end