require 'gtk3'

module Overcast
  module Gui
    class AboutWindow < Gtk::AboutDialog
      def initialize
        super
        _authors = ["Zach Tuttle"].freeze
        self.set_title("About Overcast")
        self.program_name = "Overcast"
        self.title = "About Overcast"
        self.version = "0.0.1"
        self.comments = "Overcast your backup manager!"
        self.copyright = "(c) Zach Tuttle"
        self.authors = _authors
      end

      def display
        self.run
        self.hide
      end
    end
  end
end
