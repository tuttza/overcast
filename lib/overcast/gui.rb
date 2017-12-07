require "gtk3"
require_relative "directory_store"
require_relative "directory_item"
require_relative "gui/about_window"
require_relative "gui/preferences_window"
require_relative "gui/message_window"
require_relative "gui/directory_details_window"
require_relative "gui/directory_list_view"

module Overcast
  class Application

    def self.execute
      directory_store = Overcast::DirectoryStore.new

      @window = Gtk::Window.new("Overcast")
      @window.border_width = 0
      @window.set_default_size(800, 600)
      @window.signal_connect('destroy') { Gtk.main_quit }

      box1 = Gtk::Box.new(:vertical, 0)
      box1.spacing = 6
      @window.add(box1)

      box1.pack_start(setup_menubar, expand: false, fill: false, padding: 0)

      box2 = Gtk::Box.new(:vertical)
      box2.border_width = 10
      box1.pack_start(box2, expand: true, fill: true, padding: 0)

      scroll_window = Gtk::ScrolledWindow.new
      scroll_window.set_policy(:automatic, :automatic)
      box2.pack_start(scroll_window, expand: true, fill: true, padding: 0)

      model = Gtk::ListStore.new(String, String, String)

      tree_view = Overcast::Gui::DiretoryListView.new({list_store: model, directory_store: directory_store})
      tree_view.render

      scroll_window.add_with_viewport(tree_view)

      add_button = Gtk::Button.new(label: "Add")
      add_button.can_focus = true

      directory_chooser_dialog = Gtk::FileChooserDialog.new(
          title: "Select Directory",
          action: Gtk::FileChooserAction::SELECT_FOLDER,
          buttons: [[Gtk::Stock::OPEN, Gtk::ResponseType::ACCEPT], [Gtk::Stock::CANCEL, Gtk::ResponseType::CANCEL]],
          parent: @window
      )

      message_window = Overcast::Gui::MessageWindow.new(
          {
              parent: @window,
              title: "Overcast Message",
              flags: [:modal, :destroy_with_parent],
              buttons: [
                  ["_Ok", :ok]
              ],
              message: "The directory you have selected has already been added."
          }
      )

      add_button.signal_connect("clicked") do
        dialog_result = directory_chooser_dialog.run
        if dialog_result == Gtk::ResponseType::ACCEPT
          if directory_store.directories.include?(directory_chooser_dialog.filename)
            message_window.display
          elsif directory_store.is_subdir?(directory_chooser_dialog.filename)
            message_window = Overcast::Gui::MessageWindow.new(
                {
                    parent: @window,
                    title: "Overcast Message",
                    flags: [:modal, :destroy_with_parent],
                    buttons: [
                        ["_Ok", :ok]
                    ],
                    message: "The directory you selected has been included by a parent directory"
                }
            )
            message_window.display
          else
            directory_store.add_directory(directory_chooser_dialog.filename)
            directory_chooser_dialog.hide
            tree_view.render
          end
        end

        if Gtk::ResponseType::CANCEL
          directory_chooser_dialog.hide
        end
      end

      box2.pack_start(add_button, expand: false, fill: false, padding: 0)

      remove_button = Gtk::Button.new(label: "Remove")
      remove_button.can_focus = true

      remove_button.signal_connect("clicked") do
        treeiter = tree_view.selection.selected
        directory_store.remove_directory(treeiter.get_value(0))
        model.remove(treeiter) if treeiter
      end


      box2.pack_start(remove_button, expand: false, fill: true, padding: 20)

      separator = Gtk::Separator.new(:horizontal)
      box1.pack_start(separator, expand: false, fill: true, padding: 0)
      separator.show

      @window.show_all
      Gtk.main
    end

    private

    def self.setup_menubar
      menu_bar = Gtk::MenuBar.new
      file_menu = Gtk::Menu.new
      edit_file_menu = Gtk::Menu.new
      help_file_menu = Gtk::Menu.new

      root_menu_item_file = Gtk::MenuItem.new(label: "File")
      root_menu_item_file.set_submenu(file_menu)

      root_menu_item_edit = Gtk::MenuItem.new(label: "Edit")
      root_menu_item_edit.set_submenu(edit_file_menu)

      root_menu_item_help = Gtk::MenuItem.new(label: "Help")
      root_menu_item_help.set_submenu(help_file_menu)

      submenu_item_about = Gtk::MenuItem.new(label: "About")
      submenu_item_about.signal_connect("activate") do
        about = Overcast::Gui::AboutWindow.new
        about.display
      end

      submenu_item_quit = Gtk::MenuItem.new(label: "Quit")
      submenu_item_quit.signal_connect("activate") do
        Gtk.main_quit
      end

      submenu_item_preferences = Gtk::MenuItem.new(label: "Preferences")
      submenu_item_preferences.signal_connect("activate") do
        preferences_window = Overcast::Gui::PreferencesWindow.new(Gtk::WindowType::TOPLEVEL, { parent: @window })
        preferences_window.show_all
      end

      file_menu.append(submenu_item_quit)
      edit_file_menu.append(submenu_item_preferences)
      help_file_menu.append(submenu_item_about)

      menu_bar.append(root_menu_item_file)
      menu_bar.append(root_menu_item_edit)
      menu_bar.append(root_menu_item_help)
    end
  end
end

Overcast::Application.execute
