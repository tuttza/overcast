require 'gtk3'
require_relative '../../../lib/overcast/directory_item'

module Overcast
  module Gui
    class DiretoryListView < Gtk::TreeView

      attr_accessor :list_store, :config

      def initialize(options)
        @options = options.dup
        @list_store = @options[:list_store]
        @config = @options[:config]
        # Gtk::TreeView.new(model = nil) requires a model A.K.A a Gtk::ListStore
        # to be passed to its constructor.
        super(@list_store)
        self.selection.set_mode(:single)
        setup_columns
      end

      def render
        # This method may get slow in the future, when the user has
        # more directories to refresh.
        # TODO:
        #    Create a more efficient way to update the Gtk::ListStore.
        @list_store.clear
        @config.locations.each do |location_path|
          dir_item = Overcast::DirectoryItem.new({path: location_path})
          tree_iter = @list_store.append
          tree_iter[0] = location_path
          tree_iter[1] = dir_item.size
          tree_iter[2] = dir_item.files_count.to_s
        end
      end

      private

      def setup_columns
        renderer = Gtk::CellRendererText.new

        path_column = Gtk::TreeViewColumn.new("Backup Locations", renderer, { text: 0 })
        self.append_column(path_column)
        self.expander_column

        size_column = Gtk::TreeViewColumn.new("Directory Size", renderer, { text: 1 })
        self.append_column(size_column)

        file_count_column = Gtk::TreeViewColumn.new("File Count", renderer, { text: 2 })
        self.append_column(file_count_column)
      end
    end
  end
end