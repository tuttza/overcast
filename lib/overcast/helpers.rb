module Overcast
  module Helpers
    def is_valid_path?(path)
      path = File.join(path.strip.downcase)
      Dir.exist?(path)
    end
  end
end