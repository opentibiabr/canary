local chains = {
	West = {
		[1] = { itemid = 21285, position = Position(33401, 32419, 14) },
		[2] = { itemid = 21284, position = Position(33402, 32419, 14) },
		[3] = { itemid = 21284, position = Position(33403, 32419, 14) },
		[4] = { itemid = 21286, position = Position(33404, 32419, 14) },
		[5] = { itemid = 21285, position = Position(33405, 32419, 14) },
		[6] = { itemid = 21286, position = Position(33406, 32419, 14) },
		[7] = { itemid = 2126, position = Position(33403, 32418, 14) },
		[8] = { itemid = 2126, position = Position(33404, 32418, 14) },
	},
	North = {
		[1] = { itemid = 21288, position = Position(33407, 32414, 14) },
		[2] = { itemid = 21287, position = Position(33407, 32415, 14) },
		[3] = { itemid = 21289, position = Position(33407, 32416, 14) },
		[4] = { itemid = 21288, position = Position(33407, 32417, 14) },
		[5] = { itemid = 21289, position = Position(33407, 32418, 14) },
		[6] = { itemid = 2126, position = Position(33406, 32415, 14) },
		[7] = { itemid = 2126, position = Position(33406, 32416, 14) },
	},
	East = {
		[1] = { itemid = 21285, position = Position(33408, 32419, 14) },
		[2] = { itemid = 21286, position = Position(33409, 32419, 14) },
		[3] = { itemid = 21285, position = Position(33410, 32419, 14) },
		[4] = { itemid = 21284, position = Position(33411, 32419, 14) },
		[5] = { itemid = 21286, position = Position(33412, 32419, 14) },
		[6] = { itemid = 2126, position = Position(33408, 32418, 14) },
		[7] = { itemid = 2126, position = Position(33409, 32418, 14) },
	},
	South = {
		[1] = { itemid = 21288, position = Position(33407, 32420, 14) },
		[2] = { itemid = 21289, position = Position(33407, 32421, 14) },
		[3] = { itemid = 21288, position = Position(33407, 32422, 14) },
		[4] = { itemid = 21287, position = Position(33407, 32423, 14) },
		[5] = { itemid = 21289, position = Position(33407, 32424, 14) },
		[6] = { itemid = 2126, position = Position(33406, 32420, 14) },
		[7] = { itemid = 2126, position = Position(33406, 32421, 14) },
	},
}

local ferumbrasAscendantTheShattererLevers = Action()
function ferumbrasAscendantTheShattererLevers.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.TheShatterer) >= 1 then
		player:sendCancelMessage("You cannot use this lever again.")
		return true
	end
	if item.itemid == 8911 then
		item:transform(8912)
		if item:getPosition() == Position(33385, 32410, 14) then
			for i = 1, #chains.West do
				local chain = chains.West[i]
				local bla = Tile(chain.position):getItemById(chain.itemid)
				if bla then
					bla:remove()
					Game.createMonster("Fury", { x = player:getPosition().x + math.random(-3, 3), y = player:getPosition().y + math.random(-3, 3), z = player:getPosition().z })
				end
			end
			Game.setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.TheShattererLever, math.max(Game.getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.TheShattererLever), 0) + 1)
			if Game.getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.TheShattererLever) >= 4 then
				local boss = Tile(Position(33406, 32418, 14)):getTopCreature()
				if boss and boss:getName():lower() == "the shatterer" then
					boss:teleportTo(Position(33400, 32415, 14))
					boss:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					return true
				end
			end
		elseif item:getPosition() == Position(33403, 32391, 14) then
			for i = 1, #chains.North do
				local chain = chains.North[i]
				local bla = Tile(chain.position):getItemById(chain.itemid)
				if bla then
					bla:remove()
					Game.createMonster("Destroyer", { x = player:getPosition().x + math.random(-3, 3), y = player:getPosition().y + math.random(-3, 3), z = player:getPosition().z })
				end
			end
			Game.setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.TheShattererLever, math.max(Game.getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.TheShattererLever), 0) + 1)
			if Game.getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.TheShattererLever) >= 4 then
				local boss = Tile(Position(33406, 32418, 14)):getTopCreature()
				if boss and boss:getName():lower() == "the shatterer" then
					boss:teleportTo(Position(33400, 32415, 14))
					boss:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					return true
				end
			end
		elseif item:getPosition() == Position(33430, 32418, 14) then
			for i = 1, #chains.East do
				local chain = chains.East[i]
				local bla = Tile(chain.position):getItemById(chain.itemid)
				if bla then
					bla:remove()
				end
			end
			Game.setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.TheShattererLever, math.max(Game.getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.TheShattererLever), 0) + 1)
			if Game.getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.TheShattererLever) >= 4 then
				local boss = Tile(Position(33406, 32418, 14)):getTopCreature()
				if boss and boss:getName():lower() == "the shatterer" then
					boss:teleportTo(Position(33400, 32415, 14))
					boss:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					return true
				end
			end
		elseif item:getPosition() == Position(33410, 32441, 14) then
			for i = 1, #chains.South do
				local chain = chains.South[i]
				local bla = Tile(chain.position):getItemById(chain.itemid)
				if bla then
					bla:remove()
				end
			end
			Game.setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.TheShattererLever, math.max(Game.getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.TheShattererLever), 0) + 1)
			if Game.getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.TheShattererLever) >= 4 then
				local boss = Tile(Position(33406, 32418, 14)):getTopCreature()
				if boss and boss:getName():lower() == "the shatterer" then
					boss:teleportTo(Position(33400, 32415, 14))
					boss:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					return true
				end
			end
		end
		player:say("CLICK", TALKTYPE_MONSTER_SAY, false, nil, toPosition)
	elseif item.itemid == 8912 then
		player:sendCancelMessage("Sorry, not possible.")
		return true
	end
	return true
end

ferumbrasAscendantTheShattererLevers:uid(1031, 1032, 1033, 1034)
ferumbrasAscendantTheShattererLevers:register()
