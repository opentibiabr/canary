local exitPosition = {Position(33062, 31029, 7), Position(33049, 31017, 2)}
local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier

local function clearArena()
	local spectators, spectator = Game.getSpectators(Position(33063, 31034, 3), false, false, 10, 10, 10, 10)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isPlayer() then
			spectator:teleportTo(exitPosition[2])
			exitPosition[2]:sendMagicEffect(COsNST_ME_TELEPORT)
		else
			spectator:remove()
		end
	end
end


local tireczKill = CreatureEvent("TireczKill")

function tireczKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	if targetMonster:getName():lower() ~= 'tirecz' then
		return true
	end

	local spectators, spectator = Game.getSpectators(Position({x = 33063, y = 31034, z = 3}), false, true, 10, 10, 10, 10)
	for i = 1, #spectators do
		spectator = spectators[i]
		spectator:teleportTo(exitPosition[1])
		exitPosition[1]:sendMagicEffect(CONST_ME_TELEPORT)
		spectator:say('You have won! As new champion take the ancient armor as reward before you leave.', TALKTYPE_MONSTER_SAY)
		spectator:addAchievement('Champion of Chazorai')
		if spectator:getStorageValue(TheNewFrontier.Questline) == 25 then
			spectator:setStorageValue(TheNewFrontier.Mission09[1], 2) -- Questlog: 'Mission 09: Mortal Combat'
			spectator:setStorageValue(TheNewFrontier.Questline, 26)
		end
	end

	Game.setStorageValue(TheNewFrontier.Mission09[1], -1)
	clearArena()
	return true
end

tireczKill:register()
