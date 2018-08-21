module Overcast
  module Helpers
    def is_valid_path?(path)
      path = File.join(path.strip)
      Dir.exist?(path)
    end

    def sanitize_path(path)
    	path.chomp("/")
    end
  end
end
