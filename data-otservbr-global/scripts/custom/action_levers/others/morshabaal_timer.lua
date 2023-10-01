local spawnMorsha = GlobalEvent("morshabaalSpawn")

local cfg = {
    teleportPos = {x = 33118, y = 31700, z = 7, stackpos = 1},
    teleportToPos = {x = 33075, y = 31670, z = 15},
    min = 60  
 }
  
 local function removeMagicForcefield(position)
   Tile({x = 33118, y = 31700, z = 7}):getItemById(1949):remove()
end

 function spawnMorsha.onTime()
    if(os.date("%A") == "Friday") then 
       doCreateTeleport(1949, cfg.teleportToPos, cfg.teleportPos)
       Game.broadcastMessage("I am Morshabaal, the King of this world!", MESSAGE_EVENT_ADVANCE)
       addEvent(removeMagicForcefield, cfg.min * 10 * 1000, getThingfromPos({x = 33118, y = 31700, z = 7, stackpos = 1}).uid, 1)
 
 Game.createMonster("Morshabaal", Position(33074, 31664, 15))
    end
    return true
 end

spawnMorsha:time("17:00:00")
spawnMorsha:register()