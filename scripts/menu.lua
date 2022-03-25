--[[
options = {
   ["Information"] = function(f)
      -- TODO: escape?
      mp.command_native_async({
            name = "subprocess",
            args = {"theterm", "exiftool '" .. f .. "' | less"},
            capture_stderr = true
      })
   end,
}

function trim(s)
   return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

function menu()
   -- mp.commandv("run", "notify-send", "hi " .. path)

   local stdin_str = ""
   for item, _ in pairs(options) do
      stdin_str = stdin_str .. item .. "\n"
   end

   local r = mp.command_native({
         name = "subprocess",
         stdin_data = stdin_str,
         capture_stdout = true,
         args = {"dmenu", "-l", "10"}
   })

   local path = mp.get_property("path", "")

   if r.status == 0 then
      local result = trim(r.stdout)
      options[result](path)
   end
end
]]--

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
mp.add_key_binding(nil, "menu-del", function() run_menu("Delete") end)
