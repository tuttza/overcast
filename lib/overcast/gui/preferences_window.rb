require "gtk3"

module Overcast
  module Gui
    class PreferencesWindow < Gtk::Window

      def initialize(window_type, options)
        parent = options[:parent]
        super(window_type)
        self.title = "Preferences"
        self.resizable = false
        self.set_default_size(650, 550)
        self.window_position = Gtk::WindowPosition::CENTER_ON_PARENT
        self.set_modal(true)
        self.transient_for = parent
        self.signal_connect("destroy") { self.hide }
        setup_notebook
      end

      def setup_notebook
        @notebook = Gtk::Notebook.new
        storage_locations_label = Gtk::Label.new("Storage Locations")
        scheduler_label = Gtk::Label.new("Backup Scheduler")

        storage_options_label = Gtk::Label.new("Select Backup Location:")
        separator = Gtk::Separator.new(:horizontal)

        box1 = Gtk::Box.new(:horizontal, 0)
        box1.pack_start(storage_options_label, expand: false, fill: true, padding: 0)
        
        box = Gtk::Box.new(:vertical, 0)
        box.pack_start(box1, expand: false, fill: false, padding: 0)
        #box.pack_start(storage_options_label, expand: false, fill: false, padding: 0)
        box.pack_start(init_combobox, expand: false, fill: false, padding: 0)
        box.pack_start(separator, expand: false, fill: false, padding: 0)
        separator.show

        note2 = Gtk::Label.new("Page 2")

        @notebook.append_page(box, storage_locations_label)
        @notebook.append_page(note2, scheduler_label)
        self.add(@notebook)
      end

      private 
      def init_combobox
        cb = Gtk::ComboBoxText.new
        storage_options = ['Local Drive', 'AWS', 'DropBox', 'Google Drive'].freeze
        storage_options.each { |opt| cb.append_text(opt) }
        cb.active = 0
        return cb
      end

    end
  end
end
