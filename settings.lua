--settings.lua

data:extend(
  {
    {
      type = "bool-setting",
      name = "debug-messages",
      localised_name = "debug-messages",
      localised_description = "[facDump] Should we turn on debug messages?",
      setting_type = "runtime-global",
      default_value = false
    }
  }
)
