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
      end
    end
  end
end
