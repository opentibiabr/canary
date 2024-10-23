local config = {
	bossPosition = Position(33357, 31182, 10),
	newPosition = Position(33359, 31186, 10),
	soulPosition = Position(33359, 31182, 12),
}

local monsters = {
	{ position = Position(33352, 31187, 10) },
	{ position = Position(33363, 31187, 10) },
	{ position = Position(33353, 31176, 10) },
	{ position = Position(33363, 31176, 10) },
}

local leverZyrtarch = Action()

function leverZyrtarch.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 8911 then
		if player:getPosition() ~= Position(33391, 31178, 10) then
			item:transform(8912)
			return true
		end
	end
	if item.itemid == 8911 then
		local playersTable = {}
		if player:doCheckBossRoom("Dragonking Zyrtarch", Position(33348, 31172, 10), Position(33368, 31190, 12)) then
			for d = 1, #monsters do
				Game.createMonster("soulcatcher", monsters[d].position, true, true)
			end
			Game.createMonster("dragonking zyrtarch", config.bossPosition, true, true)
			Game.createMonster("soul of dragonking zyrtarch", config.soulPosition, true, true)
			for y = 31178, 31182 do
				local playerTile = Tile(Position(33391, y, 10)):getTopCreature()
				if playerTile and playerTile:isPlayer() then
					playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
					playerTile:teleportTo(config.newPosition)
					playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					playerTile:setStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.DragonkingTimer, os.time() + 20 * 60 * 60)
					table.insert(playersTable, playerTile:getId())
				end
			end
			addEvent(kickPlayersAfterTime, 30 * 60 * 1000, playersTable, Position(33348, 31172, 10), Position(33368, 31190, 12), Position(33407, 31172, 10))
			item:transform(8912)
		end
	elseif item.itemid == 8912 then
		item:transform(8911)
	end

	return true
end

leverZyrtarch:position(Position(33391, 31177, 10))
leverZyrtarch:register()
