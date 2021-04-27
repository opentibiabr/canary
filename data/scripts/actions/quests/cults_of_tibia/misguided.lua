local function cleanMMap(frompos, topos)
	for _x= frompos.x, topos.x, 1 do
		for _y= frompos.y, topos.y, 1 do
			for _z= frompos.z, topos.z, 1 do
				local newpos = Position(_x, _y, _z)
				local tile = Tile(newpos)
				if tile and tile:getItemCount() > 0 then
					for _, it in pairs(tile:getItems()) do
						if it then
							local itemType = ItemType(it:getId())
							if itemType and not itemType:isCorpse() and not itemType:isContainer() and itemType:getWeaponType() <= WEAPON_NONE then
								it:remove()
							end
						end
					end
				end
			end
		end
	end
end

local function changeMap(mapName)
	local map = (type(Game.getStorageValue("cultsMap")) == "string" and Game.getStorageValue("cultsMap") or 'ouro')
	if map:lower() == mapName:lower() then
		return true
	end
	local frompos = Position(32523, 32323, 10)
	local topos = Position( 32573, 32477, 10)
	cleanMMap(frompos, topos)
	cleanMMap(Position(32512, 32364, 10), Position(32526, 32474, 10))
	if mapName:lower() == "ouro" then
		Game.setStorageValue("cultsMap", "ouro")
		Game.loadMap('data/world/worldchanges/ouro.otbm')
	else
		Game.setStorageValue("cultsMap", "folhas")
		Game.loadMap('data/world/worldchanges/folhas.otbm')
		addEvent(changeMap, 15000, "ouro")
	end
end

local cultsOfTibiaMisguided = Action()
function cultsOfTibiaMisguided.onUse(player, item, position, target, targetPosition)
	local monster = Monster(target)
	if not monster then
		return false
	end
	local map = (type(Game.getStorageValue("cultsMap")) == "string" and Game.getStorageValue("cultsMap") or 'ouro')
	if monster:getName():lower() == "misguided bully" or monster:getName():lower() == "misguided thief" then
		player:setStorageValue(Storage.CultsOfTibia.Misguided.Monsters, 0)
		item:remove(1)
		local pos = monster:getPosition()
		Game.createItem(28659, 1, pos)
		monster:remove()
		local newMonster = Game.createMonster("Misguided Shadow", pos)
		if newMonster then
			newMonster:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You paralyse the bully and the amulet reveals the true face of the creature behind the possession of this misguided creature.")
		local it = player:addItem(28657, 1)
		if map == "ouro" then
			changeMap("folhas")
		end
		it:decay()
	end
	return true
end

cultsOfTibiaMisguided:id(28658)
cultsOfTibiaMisguided:register()