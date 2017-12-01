require "gtk3"

module Overcast
  module Gui
    class PreferencesWindow < Gtk::Window

      def initialize
        super
        self.title = "Preferences"
        self.resizable = false
        self.set_default_size(650, 550)
        self.window_position = Gtk::WindowPosition::CENTER_ON_PARENT

        self.signal_connect("destroy") do
          self.destroy
        end
      end
    end
  end
end
