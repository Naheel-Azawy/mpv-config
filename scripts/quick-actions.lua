
-- seek video, pan image, or move playlist
function smart_arrows(dir, tiny)
   local seek_dur = 10
   local pan_amount = 0.05

   if tiny then
      seek_dur = 1
      pan_amount = 0.001
   end

   local zoom     = mp.get_property_number("video-zoom")
   local time_pos = mp.get_property_number("time-pos")
   local time_rem = mp.get_property_number("time-remaining")

   if zoom <= 0 then
      if dir == "right" then
         if time_rem == nil or time_rem <= seek_dur then
            mp.command("playlist-next")
         else
            mp.commandv("seek", seek_dur)
         end
      elseif dir == "left" then
         if time_pos == nil or time_pos <= seek_dur then
            mp.command("playlist-prev")
         else
            mp.commandv("seek", -seek_dur)
         end
      end

   else
      if dir == "up" then
         mp.commandv("script-message", "pan-image", "y",  pan_amount, "yes", "yes")
      elseif dir == "down" then
         mp.commandv("script-message", "pan-image", "y", -pan_amount, "yes", "yes")
      elseif dir == "right" then
         mp.commandv("script-message", "pan-image", "x", -pan_amount, "yes", "yes")
      elseif dir == "left" then
         mp.commandv("script-message", "pan-image", "x",  pan_amount, "yes", "yes")
      end
   end
end

function reset_or_gallery()
   local zoom = mp.get_property_number("video-zoom")
   if zoom == 0 then
      mp.command("script-message playlist-view-open")
   else
      mp.command("no-osd set video-zoom 0; script-message reset-pan-if-visible")
   end
end

mp.add_key_binding(nil, "smart-arrows", smart_arrows)
mp.add_key_binding(nil, "reset-or-gallery", reset_or_gallery)
