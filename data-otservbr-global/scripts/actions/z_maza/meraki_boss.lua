	local bosses = {
		{bossName = "Meraki Boss", bossPos = Position(33460, 31036, 7)}
	}
	
initEventMerakiBoss = function(self)
	local randId = math.random(1, #bosses)
	local bossRand = bosses[randId]

	addEvent(function() 
		Game.broadcastMessage("[BOSS] The Boss " .. bossRand.bossName .. " is coming in 1 minute.", MESSAGE_STATUS_WARNING)
	end, 1000)
	
	addEvent(function()
		Game.createMonster(bossRand.bossName, bossRand.bossPos)
		Game.broadcastMessage("[BOSS] The Boss " .. bossRand.bossName .. " invaded this world!.", MESSAGE_STATUS_WARNING)
	end, 60000)
	return true
end
	
	
-----------------------------------------------------------------------------------------------
local spawnRaids = GlobalEvent("spawnRaids")
function spawnRaids.onThink(interval, lastExecution, thinkInterval)
	initEventMerakiBoss()
	return true
end

spawnRaids:time('15:00:00')
spawnRaids:register()

local spawnRaids2 = GlobalEvent("spawnRaids2")
function spawnRaids2.onThink(interval, lastExecution, thinkInterval)
	initEventMerakiBoss()
	return true
end

spawnRaids2:time('20:30:00')
spawnRaids2:register()