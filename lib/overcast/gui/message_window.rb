require "gtk3"

module Overcast
  module Gui
    class MessageWindow < Gtk::Dialog
      #
      # options[Hash]
      # options hash valid keys:
      #  :title   - Text to display in window bar.
      #  :parent  - The Window/Container of this dialog.
      #  :flags   - Options for the dialog.
      #  :buttons - Buttons that will be display on the dialog
      #
      def initialize(options = {})
        super(options)        
        self.signal_connect("response") { self.hide }
        self.child.add(Gtk::Label.new(options[:message]))
      end

      def display
        result = self.show_all
        if result == :ok
          self.hide
        end
      end
    end
  end
end
