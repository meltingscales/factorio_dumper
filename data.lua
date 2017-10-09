--data.lua

data:extend(
  {
  	-- keybindings
    {--register a keybind.
  		type = "custom-input",
  		name = "export_data_button",
  		key_sequence = "CONTROL + SHIFT + e"
  	},

    {
      type = "custom-input",
      name = "export_data_button_2",
      key_sequence = "CONTROL + SHIFT + s"
    },

    {
      type = "custom-input",
      name = "export_data_button_3",
      key_sequence = "CONTROL + SHIFT + a"
    }

  }
)
