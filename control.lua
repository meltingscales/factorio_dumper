--control.lua


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


function printi(thing, debug)
  if (debug) then --if debug not nil
    print(thing)
  end
end

---
-- A GUI element to be used with the "export data" hotkey.
--
export_menu_gui =
{
  type="frame",
  name="export_menu_gui",
  caption="Export data!"
}


---
-- These are properties that will be read into the spreadsheet.
--
--
desired_properties =
{
  "name",
  "type",
  "localised_name",
  "localised_description",
  "stackable",
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
-- Just makes stuff nicer-looking.
--
property_dependants =
{
  fuel_category = --i.e. if this in nil, remove the below things.
  {
    "fuel_category",
    "fuel_value",
    "fuel_acceleration_multiplier",
    "fuel_top_speed_multiplier"
  },

  stackable =
  {
    "stackable",
    "stack_size"
  }
}


function itemprototypetostring(itemPrototype)

end

---
-- @return A list of properties given an item prototype.
function getItemPrototypeInfo(itemPrototype)
end

---
-- @return A list of all items.
--
function getItems()
  -- print("game.item_prototypes is "..table.tostring(game.item_prototypes)) --way too large...
  ret = {} --return array

  for name, prototype in pairs(game.item_prototypes) do
    ret[name] = {} --empty dict

    for _, property in pairs(desired_properties) do --get all properties. underscore is because we have no key.
      ret[name][property] = (prototype[property] or "nil") --if nil, mark it so we can remove later
    end

    for _, property in pairs(property_dependants) do --remove properties that we don't want
      print("checking dependants on property \'".._.."\' for item \'"..ret[name].name.."\'")
    end

    -- print(string.format("game.item_prototypes[    %s    ] =\n %s",name,table.tostring(prototype)))
    print(string.format("ret[   %s   ] = \n%s\n",name,table.tostring(ret[name])))
  end
  --done going through game.item_prototypes

  for key, val in pairs(ret) do
    -- print(table.tostring(val))
  end

  return ret
end


--this output you will always see in stdout
print('The control.lua start')
a=1
print("The global a is",a)
print("The global b is",b)
print("The <code>global</code> c is",global.c) --global is always empty at this point

function dump_items(path)

  print("lol. hi. dumping. hi. jk, not implemented.")

end

---
-- @param player A player from game.players
-- @param position A string representing a position, i.e. "top" or "middle"
-- @param elementName A string representing the name of the element
-- @param elementData A dictionary.
function toggle_gui_elt(player, position, elementName, elementData, debug)
  -- if loadstring(player..".gui."..position.."."..elementName.."") == nil then
  if (player.gui[position][elementName]) == nil then
    player.gui[position].add(elementData)
  else
    player.gui[position][elementName].destroy()
  end
end


function toggle_gui(player)

  if(player.gui.top.dumper_greeting) == nil then --if not exist, make da GUI
    player.gui.top.add{type="label", name="dumper_greeting", caption="Hi"}
  else
    player.gui.top.dumper_greeting.destroy() --remove because toggling.
  end

end

function open_export_menu(player)
  print("toggling export menu...")
  toggle_gui_elt(player, "top", "export_menu_gui", export_menu_gui)

  if (player.gui.top.export_menu_gui ~= nil) then --if gui exists
    print("getting items...")
    getItems()
  end
end


local initialization = function() --define handler
    --this output will happen when your mod is loaded to the current game for the first time (even if the game itself is not new)
   print("On init is running")
   print("The global a is",a)
   b=2
   print("The global b is",b)
   global.c=3
   print("The <code>global</code> c is",global.c)
   print"On init is done"
end
script.on_init(initialization) --register handler
--you can also define handler during the registration itself:
script.on_load(function()
    --this output will happen when the savegame is loaded and the mod was present during the save process
   print("On load is running")
   print("The global a is",a)
   print("The global b is",b)
   print("The <code>global</code> c is",global.c)
   print("On load is done")
end)

--use our registered keybind
script.on_event("export_data_button", function(event)
    print("someone did ctrl-shift-e! hi!!!")
    local player = game.players[event.player_index]
    print("player '" .. player.name .. "' did it!")
    open_export_menu(player)
end)

script.on_event("export_data_button_2", function(event)
    local player = game.players[event.player_index]
    toggle_gui(player)
end)

script.on_event("export_data_button_3", function(event)
    local player = game.players[event.player_index]
    toggle_gui_elt(player, "top", "testElt", {type="label", name="testElt", caption="ooh, functions"})
end)








print('The control.lua end') --guess when this output will take place
