local setting = {
	centerRoom = Position(33487, 32111, 9),
	range = 10,
	playerPositions = {
		Position(33583, 31844, 10),
		Position(33584, 31844, 10),
		Position(33585, 31844, 10),
		Position(33586, 31844, 10),
		Position(33587, 31844, 10),
	},
	newPositions = {
		Position(33486, 32120, 9),
		Position(33486, 32120, 9),
		Position(33486, 32120, 9),
		Position(33486, 32120, 9),
		Position(33486, 32120, 9),
	},
	minionPositions = {
		Position(33482, 32105, 9),
		Position(33484, 32105, 9),
		Position(33484, 32107, 9),
		Position(33481, 32109, 9),
		Position(33482, 32111, 9),
		Position(33488, 32106, 9),
		Position(33490, 32106, 9),
		Position(33492, 32109, 9),
		Position(33492, 32112, 9),
		Position(33490, 32112, 9),
	},
}

local leverDeathPriestShargon = Action()

function leverDeathPriestShargon.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 2772 then
		if roomIsOccupied(setting.centerRoom, false, setting.range, setting.range) then
			player:say("Someone is fighting against the boss! You need to wait awhile.", TALKTYPE_MONSTER_SAY)
			return true
		end

		local storePlayers = {}
		for i = 1, #setting.playerPositions do
			local tile = Tile(setting.playerPositions[i])
			local creature = tile and tile:getTopCreature()
			if not creature or not creature:isPlayer() then
				player:sendCancelMessage("You need 5 players to fight with Death Priest Shargon.")
				return true
			end
			storePlayers[#storePlayers + 1] = creature
		end

		if #storePlayers < 5 then
			player:sendCancelMessage("You need exactly 5 players to fight with Death Priest Shargon.")
			return true
		end

		for i = 1, #setting.minionPositions do
			Game.createMonster("greater death minion", setting.minionPositions[i])
		end
		Game.createMonster("death priest shargon", Position(33487, 32108, 9))

		for i = 1, #storePlayers do
			local playerToTeleport = storePlayers[i]
			local oldPosition = setting.playerPositions[i]
			local newPosition = setting.newPositions[i]
			if Tile(oldPosition) then
				oldPosition:sendMagicEffect(CONST_ME_POFF)
			end
			if newPosition then
				playerToTeleport:teleportTo(newPosition)
				newPosition:sendMagicEffect(CONST_ME_ENERGYAREA)
			end
		end
		item:transform(2773)
	elseif item.itemid == 2773 then
		item:transform(2772)
	end
	return true
end

leverDeathPriestShargon:uid(30002)
leverDeathPriestShargon:register()
