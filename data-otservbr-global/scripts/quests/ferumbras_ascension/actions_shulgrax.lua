local config = {
	centerRoom = Position(33485, 32786, 13),
	BossPosition = Position(33485, 32786, 13),
	playerPositions = {
		Position(33434, 32785, 13),
		Position(33434, 32786, 13),
		Position(33434, 32787, 13),
		Position(33434, 32788, 13),
		Position(33434, 32789, 13),
	},
	newPosition = Position(33485, 32790, 13),
}

local leverShulgrax = Action()

function leverShulgrax.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 8911 then
		if player:getPosition() ~= Position(33434, 32785, 13) then
			item:transform(8912)
			return true
		end
	end
	if item.itemid == 8911 then
		local playersTable = {}
		if player:doCheckBossRoom("Shulgrax", Position(33473, 32776, 13), Position(33496, 32798, 13)) then
			local specs, spec = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15)
			for i = 1, #specs do
				spec = specs[i]
				if spec:isPlayer() then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting with Shulgrax.")
					return true
				end
			end
			Game.createMonster("Shulgrax", config.BossPosition, true, true)
			for y = 32785, 32789 do
				local playerTile = Tile(Position(33434, y, 13)):getTopCreature()
				if playerTile and playerTile:isPlayer() then
					playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
					playerTile:teleportTo(config.newPosition)
					playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					playerTile:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.ShulgraxTimer, os.time() + 60 * 60 * 2 * 24)
					table.insert(playersTable, playerTile:getId())
				end
			end
			addEvent(kickPlayersAfterTime, 30 * 60 * 1000, playersTable, Position(33473, 32776, 13), Position(33496, 32798, 13), Position(33319, 32318, 13))
			item:transform(8912)
		end
	elseif item.itemid == 8912 then
		item:transform(8911)
	end

	return true
end

leverShulgrax:uid(1028)
leverShulgrax:register()
