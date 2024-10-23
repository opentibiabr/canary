local config = {
	centerRoom = Position(32624, 32880, 14),
	bossPosition = Position(32624, 32880, 14),
	newPosition = Position(32624, 32886, 14),
}

local leverThornKnight = Action()

function leverThornKnight.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 8911 then
		if player:getPosition() ~= Position(32657, 32877, 14) then
			item:transform(8912)
			return true
		end
	end
	if item.itemid == 8911 then
		local playersTable = {}
		if player:doCheckBossRoom("Thorn Knight", Position(32613, 32869, 14), Position(32636, 32892, 14)) then
			for d = 1, 6 do
				Game.createMonster("possessed tree", Position(math.random(32619, 32629), math.random(32877, 32884), 14), true, true)
			end
			Game.createMonster("mounted thorn knight", config.bossPosition, true, true)
			for y = 32877, 32881 do
				local playerTile = Tile(Position(32657, y, 14)):getTopCreature()
				if playerTile and playerTile:isPlayer() then
					playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
					playerTile:teleportTo(config.newPosition)
					playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					playerTile:setStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.ThornKnightTimer, os.stime() + 20 * 60 * 60)
					table.insert(playersTable, playerTile:getId())
				end
			end
			addEvent(kickPlayersAfterTime, 30 * 60 * 1000, playersTable, Position(32613, 32869, 14), Position(32636, 32892, 14), Position(32678, 32888, 14))
			item:transform(8912)
		end
	elseif item.itemid == 8912 then
		item:transform(8911)
	end
	return true
end

leverThornKnight:position(Position(32657, 32876, 14))
leverThornKnight:register()
