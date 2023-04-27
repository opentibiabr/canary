local tps = {
	[4602] = {
		storage = Storage.Quest.FeasterOfSouls.Bosses.IrgixTheFlimsy.Timer,
		bossName = "Irgix the Flimsy", 
		bossPosition = Position({x = 33467, y = 31399, z = 8}), 
		centerPosition = Position({x = 33467, y = 31400, z = 8}), 
		newPos = Position({x = 33467, y = 31405, z = 8}), 
		kickPos = Position({x = 33493, y = 31400, z = 8}), 
		centerRangeX = 8, 
		centerRangeY = 8
	},
	[4603] = {exitPos = Position({x = 33493, y = 31400, z = 8})},
	
	[4600] = {
		storage = Storage.Quest.FeasterOfSouls.Bosses.UnazTheMean.Timer,
		bossName = "Unaz the Mean", 
		bossPosition = Position({x = 33565, y = 31496, z = 8}), 
		centerPosition = Position({x = 33571, y = 31495, z = 8}), 
		newPos = Position({x = 33576, y = 31494, z = 8}), 
		kickPos = Position({x = 33563, y = 31477, z = 8}), 
		centerRangeX = 12, 
		centerRangeY = 6
	},
	[4601] = {exitPos = Position({x = 33563, y = 31477, z = 8})},
	
	[4604] = {
		storage = Storage.Quest.FeasterOfSouls.Bosses.VokTheFreakish.Timer,
		bossName = "Vok the Freakish", 
		bossPosition = Position({x = 33508, y = 31486, z = 9}), 
		centerPosition = Position({x = 33508, y = 31490, z = 9}),
		newPos = Position({x = 33508, y = 31494, z = 9}), 
		kickPos = Position({x = 33510, y = 31452, z = 9}), 
		centerRangeX = 8, 
		centerRangeY = 8
	},
	[4605] = {exitPos = Position({x = 33510, y = 31452, z = 9})},
}
local miniBosses = MoveEvent()

function miniBosses.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local aid = item:getActionId()
	local data = tps[aid]
	if not data then
		player:teleportTo(fromPosition, true)
		return true
	end
	if data.exitPos then
		player:teleportTo(data.exitPos)
		data.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
		position:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
	if player:getStorageValue(data.storage) > os.time() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have faced this boss in the last 20 hours.")
		player:teleportTo(fromPosition, true)
		fromPosition:sendMagicEffect(CONST_ME_POFF)
		return true
	end
	local spectators = Game.getSpectators(Position(data.centerPosition), false, false, data.centerRangeX, data.centerRangeX, data.centerRangeY, data.centerRangeY)       
	for index, tempCreature in ipairs(spectators) do
		if tempCreature:isPlayer() then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There's someone fighting this boss.")
			player:teleportTo(fromPosition, true)
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end
	end	
	
	for index, tempCreature in ipairs(spectators) do
		if tempCreature:isMonster() then
			tempCreature:remove()
		end
	end
	local boss = Game.createMonster(data.bossName, data.bossPosition)
	if not boss then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There's an error, please contact a GM.")
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
	player:setStorageValue(data.storage, os.time() + 20*60*60)
	position:sendMagicEffect(CONST_ME_TELEPORT)
	data.newPos:sendMagicEffect(CONST_ME_TELEPORT)
	player:teleportTo(data.newPos)
	addEvent(function(id)
		if not Player(id) then
			return false
		end
		local spec = Game.getSpectators(Position(data.centerPosition), false, true, data.centerRangeX, data.centerRangeX, data.centerRangeY, data.centerRangeY)
		for _, pid in pairs(spec) do
			if pid:getId() == id then
				pid:teleportTo(data.kickPos)
				data.kickPos:sendMagicEffect(CONST_ME_TELEPORT)
				pid:sendCancelMessage("You weren't able to kill the boss.")
				break
			end
		end
		end, 15 * 60 * 1000, player:getId())
	return true
end

miniBosses:type("stepin")
for id, data in pairs(tps) do
	miniBosses:aid(id)
end
miniBosses:register()
