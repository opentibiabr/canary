local chains = {
	West = {
		[1] = {itemid = 23656, position = Position(33401, 32419, 14)},
		[2] = {itemid = 23655, position = Position(33402, 32419, 14)},
		[3] = {itemid = 23655, position = Position(33403, 32419, 14)},
		[4] = {itemid = 23657, position = Position(33404, 32419, 14)},
		[5] = {itemid = 23656, position = Position(33405, 32419, 14)},
		[6] = {itemid = 23657, position = Position(33406, 32419, 14)},
		[7] = {itemid = 1495, position = Position(33403, 32418, 14)},
		[8] = {itemid = 1495, position = Position(33404, 32418, 14)}
	},
	North = {
		[1] = {itemid = 23659, position = Position(33407, 32414, 14)},
		[2] = {itemid = 23658, position = Position(33407, 32415, 14)},
		[3] = {itemid = 23660, position = Position(33407, 32416, 14)},
		[4] = {itemid = 23659, position = Position(33407, 32417, 14)},
		[5] = {itemid = 23660, position = Position(33407, 32418, 14)},
		[6] = {itemid = 1495, position = Position(33406, 32415, 14)},
		[7] = {itemid = 1495, position = Position(33406, 32416, 14)}
	},
	East = {
		[1] = {itemid = 23656, position = Position(33408, 32419, 14)},
		[2] = {itemid = 23657, position = Position(33409, 32419, 14)},
		[3] = {itemid = 23656, position = Position(33410, 32419, 14)},
		[4] = {itemid = 23655, position = Position(33411, 32419, 14)},
		[5] = {itemid = 23657, position = Position(33412, 32419, 14)},
		[6] = {itemid = 1495, position = Position(33408, 32418, 14)},
		[7] = {itemid = 1495, position = Position(33409, 32418, 14)}
	},
	South = {
		[1] = {itemid = 23659, position = Position(33407, 32420, 14)},
		[2] = {itemid = 23660, position = Position(33407, 32421, 14)},
		[3] = {itemid = 23659, position = Position(33407, 32422, 14)},
		[4] = {itemid = 23658, position = Position(33407, 32423, 14)},
		[5] = {itemid = 23660, position = Position(33407, 32424, 14)},
		[6] = {itemid = 1495, position = Position(33406, 32420, 14)},
		[7] = {itemid = 1495, position = Position(33406, 32421, 14)}
	}
}

local ferumbrasAscendantTheShattererLevers = Action()
function ferumbrasAscendantTheShattererLevers.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.FerumbrasAscension.TheShatterer) >= 1 then
		player:sendCancelMessage('You cannot use this lever again.')
		return true
	end
	if item.itemid == 9825 then
		item:transform(9826)
		if item:getPosition() == Position(33385, 32410, 14) then
			for i = 1, #chains.West do
				local chain = chains.West[i]
				local bla = Tile(chain.position):getItemById(chain.itemid)
				if bla then
					bla:remove()
					Game.createMonster("Fury", { x=player:getPosition().x+math.random(-3, 3), y=player:getPosition().y+math.random(-3, 3), z=player:getPosition().z })
				end
			end
			Game.setStorageValue(GlobalStorage.FerumbrasAscendant.TheShattererLever, Game.getStorageValue(GlobalStorage.FerumbrasAscendant.TheShattererLever) + 1)
			if Game.getStorageValue(GlobalStorage.FerumbrasAscendant.TheShattererLever) >= 4 then
				local boss = Tile(Position(33406, 32418, 14)):getTopCreature()
				if boss:getName():lower() == 'the shatterer' then
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
					Game.createMonster("Destroyer", { x=player:getPosition().x+math.random(-3, 3), y=player:getPosition().y+math.random(-3, 3), z=player:getPosition().z })
				end
			end
			Game.setStorageValue(GlobalStorage.FerumbrasAscendant.TheShattererLever, Game.getStorageValue(GlobalStorage.FerumbrasAscendant.TheShattererLever) + 1)
			if Game.getStorageValue(GlobalStorage.FerumbrasAscendant.TheShattererLever) >= 4 then
				local boss = Tile(Position(33406, 32418, 14)):getTopCreature()
				if boss:getName():lower() == 'the shatterer' then
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
			Game.setStorageValue(GlobalStorage.FerumbrasAscendant.TheShattererLever, Game.getStorageValue(GlobalStorage.FerumbrasAscendant.TheShattererLever) + 1)
			if Game.getStorageValue(GlobalStorage.FerumbrasAscendant.TheShattererLever) >= 4 then
				local boss = Tile(Position(33406, 32418, 14)):getTopCreature()
				if boss:getName():lower() == 'the shatterer' then
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
			Game.setStorageValue(GlobalStorage.FerumbrasAscendant.TheShattererLever, Game.getStorageValue(GlobalStorage.FerumbrasAscendant.TheShattererLever) + 1)
			if Game.getStorageValue(GlobalStorage.FerumbrasAscendant.TheShattererLever) >= 4 then
				local boss = Tile(Position(33406, 32418, 14)):getTopCreature()
				if boss:getName():lower() == 'the shatterer' then
					boss:teleportTo(Position(33400, 32415, 14))
					boss:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					return true
				end
			end
		end
		player:say('CLICK', TALKTYPE_MONSTER_SAY, false, nil, toPosition)
	elseif item.itemid == 9826 then
		player:sendCancelMessage('Sorry, not possible.')
		return true
	end
	return true
end

ferumbrasAscendantTheShattererLevers:uid(1031,1032,1033,1034)
ferumbrasAscendantTheShattererLevers:register()