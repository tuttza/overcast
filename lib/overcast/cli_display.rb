require "colorize"

module Overcast
	module CLI
    class Display
      def initialize(options = {})
        @directory_items = options[:directory_items]
      end

      def render_directory_list
        @directory_items.each_with_index do |dir_item, index|
          number_label = index + 1
          path = dir_item.path
          size = dir_item.size
          files_count = dir_item.files_count
          puts "#{number_label}. #{path} | #{size} | #{files_count}".colorize(random_color)
        end
      end
      
      private
      
      def colors
        String.colors
      end

      def random_color
        colors.reject { |s| s == :black || s == :light_black }.sample
      end
    end
  end
end
