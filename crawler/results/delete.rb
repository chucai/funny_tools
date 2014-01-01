Dir.glob("*.txt").each do |item|
  File.delete(item) if File.exist? item
end
