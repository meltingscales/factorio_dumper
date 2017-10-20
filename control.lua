--control.lua
require "util"


function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
    tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
      table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end


function printif(thing, boolean)
  if (boolean == true) then --if boolean not nil
    print(thing)
  end
end

function pr(thing, boolean)
  if(boolean == nil) then
    boolean = global.debug
  end
  printif(brand.."  "..tostring(thing),debug)
end


local color_a =
{
  r=0.8,
  g=0,
  b=0.8,
  a=1
}

local color_b =
{
  r=0.5,
  g=0.5,
  b=0,
  a=0
}

local color_c =
{
  r=0,
  g=1,
  b=1,
  a=0.2
}

local test_child_elt =
{
  type="frame",
  name="export_menu_option_button",
  caption="test"
}

local test_style =
{
  minimal_width = 700,
  minimal_height = 500,
  maximal_width = 900,
  maximal_height = 900,
  font_color = color_a
}

brand = "[facDump]"
where_path = "Name to export a .csv file to.\nWill be found inside of:\nC:\\Users\\USERNAME\\AppData\\Roaming\\Factorio\\script-output"
BLANK_ITEM = " "
DELIMITER = ","


---
-- A GUI element to be used with the "export data" hotkey.
--
local gui_root =
{
  type = "frame",
  name = "gui_root",
  caption = "Export data!"
}




---
-- These are properties that will be read into the spreadsheet.
-- They will also be put into the spreadsheet's headers.
--
desired_properties =
{
  "name",
  "type",
  "stack_size",
  "fuel_category",
  "fuel_value",
  "fuel_acceleration_multiplier",
  "fuel_top_speed_multiplier"
}

---
-- This is a list of properties that, when zero or nil, will
-- remove all child properties.
--
-- For example, if something's fuel_category is nil, it shouldn't have
-- a fuel_category, fuel_value, fuel_acceleration_multiplier, etc.
-- Just makes stuff nicer-looking when printing it.
--
property_dependants =
{
  fuel_category = --i.e. if this in nil, remove the below things.
  {
    "fuel_category",
    "fuel_value",
    "fuel_acceleration_multiplier",
    "fuel_top_speed_multiplier"
  }
}



function init()

  global.debug = settings.global['debug-messages'].value


end


---
--
--
--
function apply_style(LuaGui, LuaStyle, debug)
  for key, value in pairs(LuaStyle) do
    pr(string.format("doing LuaGui.style.%s = %s",key,value),debug)
    LuaGui.style[key] = value
  end
end


---
-- @return A list of all items.
--
function getItems()
  -- pr("game.item_prototypes is "..table.tostring(game.item_prototypes)) --way too large...
  ret = {} --return array

  for name, prototype in pairs(game.item_prototypes) do
    ret[name] = {} --empty dict

    for _, property in pairs(desired_properties) do --get all properties. underscore is because we have no key.
      ret[name][property] = (prototype[property] or "nil") --if nil, mark it so we can remove later
    end

    for parent, child in pairs(property_dependants) do --check if any parents don't exist
      pr("checking dependants on property \'"..parent.."\' for item \'"..ret[name].name.."\'",debug)

      if(ret[name][parent] == "nil") then
        pr(string.format("\n   !!!we should remove ret[%s][%s] = %s and all its related properties, %s",name,parent,ret[parent],table.tostring(property_dependants[parent])),debug)

        for _, dependant in pairs(property_dependants[parent]) do --actually remove the children
          pr(string.format("deleting ret[%s][%s]",name,dependant),debug)
          ret[name][dependant] = nil
        end

        pr("\n\n",debug)
      end

    end

    -- pr(string.format("game.item_prototypes[    %s    ] =\n %s",name,table.tostring(prototype)))
    pr(string.format("ret[   %s   ] = \n%s\n",name,table.tostring(ret[name])),debug)
  end
  --done going through game.item_prototypes

  return ret
end

---
-- @param player A player from game.players
-- @param position A string representing a position, i.e. "top" or "middle"
-- @param elementName A string representing the name of the element
-- @param elementData A dictionary.
function toggle_gui_elt(player, position, elementName, elementData, debug)
  -- if loadstring(player..".gui."..position.."."..elementName.."") == nil then
  if (player.gui[position][elementName]) == nil then
    player.gui[position].add(elementData) --add all layout stuff
  else
    while(player.gui[position][elementName] ~= nil) do
      player.gui[position][elementName].destroy()
    end
  end
end


function open_export_menu(player, debug)
  pr("toggling export menu...",debug)

  toggle_gui_elt(player, "top", gui_root.name, gui_root)
  
  local p = player
  
  if (player.gui.top.gui_root ~= nil) then --if gui exists

    apply_style(player.gui.top.gui_root, test_style)

    player.gui.top.gui_root.add({type="frame", name="path_frame"})

    player.gui.top.gui_root.path_frame.add({type="label", name="", caption="Name"})
    player.gui.top.gui_root.path_frame.add({type="textfield", name="path_textbox", text="factorio-items.csv", tooltip=where_path})

    --table to toggle columns! turning desired_properties items on or off
    player.gui.top.gui_root.add({type="frame", name="fields_frame", tooltip=name})
    player.gui.top.gui_root.fields_frame.add({name="fields_table",type="table",colspan=4})
    
    local prepend = "fields_"
    local buttonIDer = "_button"
    

    --add all properties to allow player to select from them.
    for i = 1, #desired_properties do
      local tooltipName = "toggle \""..desired_properties[i].."\" column in output file?"
      
      
      player.gui.top.gui_root.fields_frame.fields_table.add({
        type="label",
        tooltip = tooltipName,
        name=prepend..desired_properties[i],
        caption=desired_properties[i],
      })
      
      player.gui.top.gui_root.fields_frame.fields_table.add({
        type="checkbox",
        state=true,
        name=prepend..desired_properties[i]..buttonIDer,
        tooltip=tooltipName
      })
    end


    
    --button to export stuff.
    --event listener is created elsewhere that calls export_items.
    player.gui.top.gui_root.add({type="button", name="exportButton", caption="Export!" })

  end
end

function export_items(player, path, data, debug)
  pr("exporting bruh.",debug)

  itemsData = getItems()


  out = ""

  for _, property in pairs(desired_properties) do
    out = out .. property .. DELIMITER --append header column
  end

  out = out .. "\n"

  for itemname, itemproperties in pairs(itemsData) do
    pr(string.format("itemsData[%s]:",itemname))

    for _, property in pairs(desired_properties) do
      if(itemsData[itemname][property] ~= nil) then
        pr(string.format("itemsData[%s][%s] = %s",itemname,property,itemsData[itemname][property]))
        out = out .. itemsData[itemname][property] --append 20 or "iron_plate"
      else
        out = out .. BLANK_ITEM --add 0 or NULL or something else 
      end
      
      out = out .. DELIMITER --unconditionally add delimiter
      
    end

    out = out .. "\n"

    pr("\n",debug)



  end

  player.print("Successfully exported data to \'factorio\\script-output\\"..path.."\'!")

  pr(string.format("out is: \'\'\'%s\'\'\'",out),debug)

  game.write_file(path, out)

end



script.on_configuration_changed(
  function()

    debug = settings.global['debug-messages'].value
    pr("config updated!",true)
    

  end
)


script.on_event(defines.events.on_player_created,
function(event)
  for i, player in pairs(game.players) do
    --  player.gui.top.gui_root.destroy()
    --  pr("destroying gui bruh")
  end
end
)

-- script.on_init(initialization) --register handler
--you can also define handler during the registration itself:
script.on_init(function()
    --this output will happen when the savegame is loaded and the mod was present during the save process
    pr("FIRST TIME LOAD!!!")

    debug = settings.global['debug-messages'].value
    
    
    if(debug) then
      pr("Debug for factoriodumper enabled!")
    else
      pr("Debug for factoriodumper disabled!")
    end


end)

--event handler for clicking on a GUI
script.on_event(defines.events.on_gui_click, function(event)
    local player = game.players[event.player_index]

    pr(string.format("clicked element named '%s'",event.element.name))

    if (event.element.name == "exportButton") then
      pr(string.format("Exporting data to %s",event.element.parent.path_frame.path_textbox.text),debug)


      export_items(player, event.element.parent.path_frame.path_textbox.text,data)
    end
end)

script.on_event(defines.events.on_player_joined_game, function(event)
  local player = game.players[event.player_index]

  pr("someone joined the game!!!\n\n\n")

end)

--use our registered keybind
script.on_event("export_data_button", function(event)
    pr("someone did ctrl-shift-e! hi!!!")
    local player = game.players[event.player_index]
    pr("player '" .. player.name .. "' did it!")
    open_export_menu(player)
    pr("")
end)

script.on_event("export_data_button_2", function(event)
    local player = game.players[event.player_index]
    toggle_gui_elt(player, "top", "dumper_greeting", {type="label", name="dumper_greeting", caption="ctrl-shift-s hello"})
end)

script.on_event("export_data_button_3", function(event)
    local player = game.players[event.player_index]
    toggle_gui_elt(player, "top", "testElt", {type="label", name="testElt", caption="ooh, functions"})
end)



pr('The control.lua end') --guess when this output will take place
