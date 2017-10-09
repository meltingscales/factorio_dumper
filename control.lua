--control.lua

--this output you will always see in stdout

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
