require 'gtk3'

module Overcast
  module Gui
    class DirectoryDetailsWindow < Gtk::Window

      def initialize(window_type, options = {})
        @directory_item = options[:directory_item]
        parent = options[:parent]
        super(window_type)
        self.set_title("Directory Details [#{@directory_item.path}]")
        self.resizable = false
        self.border_width = 0
        self.set_default_size(350, 200)
        self.set_modal(true)
        self.transient_for = parent
        self.window_position = Gtk::WindowPosition::CENTER_ON_PARENT # or :center_on_parent
        self.signal_connect("destroy") { self.hide }
        box= Gtk::Box.new(:vertical, 0)
        box.spacing = 6
        directory_files_count_label = Gtk::Label.new("# of Files:  #{@directory_item.files_count}")
        box.pack_start(directory_files_count_label, expand: false, fill: true, padding: 0)
        directory_size_label = Gtk::Label.new("Directory Size:  #{@directory_item.size}")
        box.pack_start(directory_size_label, expand: false, fill: true, padding: 0)
        self.add(box)
      end
    end
  end
end