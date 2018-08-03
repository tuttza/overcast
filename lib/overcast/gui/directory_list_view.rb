require 'gtk3'
require_relative '../../../lib/overcast/directory_item'

module Overcast
  module Gui
    class DiretoryListView < Gtk::TreeView

      attr_accessor :list_store, :directory_store

      def initialize(options)
        @options = options.dup
        @list_store = @options[:list_store]
        @directory_store = @options[:directory_store]
        # Gtk::TreeView.new(model = nil) requires a model a.k.a an Gtk::ListStore
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
        @directory_store.directories.each do |dir_path|
          dir_item = Overcast::DirectoryItem.new({ path: dir_path })
          tree_iter = @list_store.append
          tree_iter[0] = dir_path
          tree_iter[1] = dir_item.size
          tree_iter[2] = dir_item.files_count.to_s
        end
      end

      def open_system_file_explorer
        self.signal_connect("row-activated") do 
          treeiter = self.selection.selected
          path = treeiter.get_value(0)
          system("open #{path}")
        end
      end

      def remove_item
        treeiter = self.selection.selected
        @directory_store.remove_directory(treeiter.get_value(0))
        @list_store.remove(treeiter) if treeiter
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