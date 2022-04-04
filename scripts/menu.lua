local utils = require 'mp.utils'

function run_menu(key)
   local home = os.getenv("HOME")
   local path = mp.get_property("path", "")

   if key == nil then
      key = "menu"
   end

   local r = mp.command_native({
         name = "subprocess",
         stdin_data = stdin_str,
         capture_stdout = true,
         args = {
            home .. "/.config/mpv/menu.sh", -- TODO: xdg config
            key, path
         }
   })

   if r.status == 0 then
      mp.command("playlist-play-index current")
   end

end

mp.add_key_binding(nil, "menu", run_menu)
