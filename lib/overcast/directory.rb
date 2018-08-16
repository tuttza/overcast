
module Overcast
	class Directory

	def initialize(options = {})
    @directory_items = options[:directory_items]
	end

    def display_all
      @directory_items.each_with_index do |dir_item, index|
    		path = dir_item.path.colorize(color: :green, background: :blue)
    		size = dir_item.size.colorize(color: :light_red, background: :blue)
    		files_count = dir_item.files_count.to_s.colorize(color: :light_yellow, background: :blue)
    		bar_size = path.length + size.length
    		text_bar =  "*" * bar_size

    		puts text_bar
    		puts "Directory: #{path}"
    		puts "Directtory Size: #{size}"
    		puts "# of Files: #{files_count}"
    		puts text_bar
    	end
    end

	end
end