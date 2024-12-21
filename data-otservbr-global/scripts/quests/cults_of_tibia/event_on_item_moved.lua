local callback = EventCallback("CultsOnItemMoved")

function callback.onItemMoved(item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	local fromPos = Position(33023, 31904, 14)
	local toPos = Position(33052, 31932, 15)

	if player:getPosition():isInRange(fromPos, toPos) and item:getId() == 23729 then
		local tile = Tile(toPosition)
		if not tile then
			return
		end

		local tileBoss = tile:getTopCreature()
		if not (tileBoss and tileBoss:isMonster()) then
			return
		end

		local bossName = tileBoss:getName():lower()
		if bossName == "the remorseless corruptor" then
			tileBoss:addHealth(-17000)
			tileBoss:remove()

			local monster = Game.createMonster("The Corruptor of Souls", toPosition)
			if not monster then
				return
			end

			monster:registerEvent("CheckTile")

			local storedHealth = Game.getStorageValue("healthSoul")
			if storedHealth > 0 then
				monster:addHealth(-(monster:getHealth() - storedHealth))
			end

			Game.setStorageValue("CheckTile", os.time() + 30)
			item:remove(1)
		elseif bossName == "the corruptor of souls" then
			Game.setStorageValue("CheckTile", os.time() + 30)
			item:remove(1)
		end
	end
end

callback:register()
