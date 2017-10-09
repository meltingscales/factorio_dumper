--settings.lua

data:extend(
  {
    {
      type = "bool-setting",
      name = "my-mod-test-setting",
      localised_description = "A test setting.",
      setting_type = "runtime-global",
      default_value = true
    }
  }
)
