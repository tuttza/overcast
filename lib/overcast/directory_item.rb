module Overcast
  class DirectoryItem
    attr_accessor :path

    def initialize(options = {})
      @path = options[:path]
      @pattern = options[:pattern]
    end

    def files
      Dir.glob(File.join(@path, "**", "*"))
    end

    def size
      bytes = files.map { |file| File.size(file) }.inject(:+).to_f
      bytes_to_size(bytes).to_s
    end

    def files_count
     files.select { |file| File.file?(file) }.count
    end

    private

    def bytes_to_size(bytes)
      units = ['B', 'KiB', 'MiB', 'GiB', 'TiB', 'Pib', 'EiB'].freeze

      return '0.0 B' if bytes.zero?

      exp = (Math.log(bytes) / Math.log(1024)).to_i

      '%.1f %s' % [bytes.to_f / (1024 ** exp), units[exp]]
    end

  end
end
