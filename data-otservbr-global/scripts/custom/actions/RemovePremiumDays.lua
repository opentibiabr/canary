
 local removePremiumDays = GlobalEvent("RemovePremiumDays")

function removePremiumDays.onThink(interval)
local players = Game.getPlayers()
 if #players == 0 then
       return true
     end
     db.query("UPDATE `accounts` SET `premdays` = `premdays` - 1 WHERE `premdays` > 0")
 return true
end

removePremiumDays:interval(64800000)
removePremiumDays:register()