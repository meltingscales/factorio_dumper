--settings.lua

data:extend(
  {
    {
      type = "bool-setting",
      name = "debug-messages",
      order = "aa",
      setting_type = "runtime-global",
      localised_name = "Debug messages?",
      localised_description = "[facDump] Should we turn on debug messages?",
      default_value = false,
      per_user = true
    }
  }
)
