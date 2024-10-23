local config = {
	{ newPosition = Position(31985, 32851, 14) },
	{ pos = Position(31986, 32840, 14), monster = "a shielded astral glyph" },
	{ pos = Position(31975, 32856, 15), monster = "bound astral power" },
	{ pos = Position(31987, 32839, 14), monster = "the astral source" },
	{ pos = Position(31986, 32823, 15), monster = "the distorted astral source" },
	{ pos = Position(31989, 32823, 15), monster = "an astral glyph" },
}

local leverLoreKeeper = Action()

function leverLoreKeeper.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 8911 then
		if player:getPosition() ~= Position(32019, 32844, 14) then
			item:transform(8912)
			return true
		end
	end
	if item.itemid == 8911 then
		local playersTable = {}
		if player:doCheckBossRoom("The Last Lorekeeper", Position(31968, 32821, 14), Position(32004, 32865, 15)) then
			for x = 32018, 32020 do
				for y = 32844, 32848 do
					local playerTile = Tile(Position(x, y, 14)):getTopCreature()
					if playerTile and playerTile:isPlayer() then
						playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
						playerTile:teleportTo(config[1].newPosition)
						playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
						playerTile:setStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.LastLoreTimer, os.time() + 60 * 60 * 14 * 24)
						table.insert(playersTable, playerTile:getId())
					end
				end
			end
			for b = 2, #config do
				Game.createMonster(config[b].monster, config[b].pos, true, true)
			end
			Game.setStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.AstralPowerCounter, 1)
			Game.setStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.AstralGlyph, 0)
			player:say("The Astral Glyph begins to draw upon bound astral power to expel you from the room!", TALKTYPE_MONSTER_SAY)
			addEvent(kickPlayersAfterTime, 30 * 60 * 1000, playersTable, Position(31968, 32821, 14), Position(32004, 32865, 15), Position(32035, 32859, 14))
			item:transform(8912)
		end
	elseif item.itemid == 8912 then
		item:transform(8911)
	end

	return true
end

leverLoreKeeper:position(Position(32019, 32843, 14))
leverLoreKeeper:register()
