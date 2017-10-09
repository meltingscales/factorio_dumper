--control.lua

--this output you will always see in stdout

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


print('The control.lua start')
a=1
print("The global a is",a)
print("The global b is",b)
print("The <code>global</code> c is",global.c) --global is always empty at this point


function create_gui(player)
  game.player.gui.left.add
  {
    type = "sprite-button",
    name = "My_mod_button",
    sprite = "item/my-mod-item",
    style = "My-mod-button-style"
  }
end

function open_export_menu(player)
  game.player.gui.top.greetin g.name == "U WANT EXPORT MENU???"
end 


local initialization = function() --define handler
    --this output will happen when your mod is loaded to the current game for the first time (even if the game itself is not new)
   print"On init is running"
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
    print("someone did ctrl-shift-e! hi1!!!")
    local player = game.players[event.player_index]
    create_gui(player)
end)






print('The control.lua end') --guess when this output will take place
