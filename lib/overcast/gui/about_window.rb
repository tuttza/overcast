require 'gtk3'

module Overcast
  module Gui
    class AboutWindow < Gtk::AboutDialog
      def initialize
        super
        authors = ["Zach Tuttle"].freeze
        self.set_title("About Overcast")
        self.program_name = "Overcast"
        self.title = "About Overcast"
        self.version = "0.0.1"
        self.comments = "Overcast your backup manager!"
        self.copyright = "(c) Zach Tuttle"
        self.set_window_position(Gtk::WindowPosition::CENTER)
        self.authors = authors
      end

      def set_parent=(parent)
        self.transient_for = parent
      end

      def display
        self.run
        self.hide
      end
    end
  end
end
