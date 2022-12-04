local setting = {
	arenaPosition = Position(33154, 31415, 7),
	successPosition = Position(33145, 31419, 7),
}
local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier

local function completeTest(cid)
	local player = Player(cid)
	if not player then
		return false
	end
	if player:getStorageValue(TheNewFrontier.Questline) == 17 then
		player:teleportTo(setting.successPosition)
		player:setStorageValue(TheNewFrontier.Questline, 18)
		player:setStorageValue(TheNewFrontier.Mission06, 3) --Questlog, The New Frontier Quest "Mission 06: Days Of Doom"
		player:say("You have braved the tiral of the Mooh'tah master.", TALKTYPE_MONSTER_SAY)
	end
end

local minotaurBoss = MoveEvent()

function minotaurBoss.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if Position.hasPlayer(setting.arenaPosition, 6, 6) or player:getStorageValue(TheNewFrontier.Questline) ~= 17 then
		player:teleportTo(fromPosition)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		return player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have access to this area.")
	end

	addEvent(completeTest, 2 * 60 * 1000, player.uid)
	player:teleportTo(setting.arenaPosition)
	setting.arenaPosition:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

minotaurBoss:position(Position(33146, 31413, 6))
minotaurBoss:register()
