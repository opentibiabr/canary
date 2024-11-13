local callback = EventCallback("CultsOnItemMoved")

function callback.onItemMoved(item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	local fromPos = Position(33023, 31904, 14)
	local toPos = Position(33052, 31932, 15)
	local removeItem = false

	if player:getPosition():isInRange(fromPos, toPos) and item:getId() == 23729 then
		local tile = Tile(toPosition)
		if tile then
			local tileBoss = tile:getTopCreature()
			if tileBoss and tileBoss:isMonster() then
				local bossName = tileBoss:getName():lower()
				if bossName == "the remorseless corruptor" then
					tileBoss:addHealth(-17000)
					tileBoss:remove()

					local monster = Game.createMonster("The Corruptor of Souls", toPosition)
					if not monster then
						return false
					end

					removeItem = true
					monster:registerEvent("CheckTile")

					local storedHealth = Game.getStorageValue("healthSoul")
					if storedHealth > 0 then
						monster:addHealth(-(monster:getHealth() - storedHealth))
					end

					Game.setStorageValue("CheckTile", os.time() + 30)
				elseif bossName == "the corruptor of souls" then
					Game.setStorageValue("CheckTile", os.time() + 30)
					removeItem = true
				end
			end
		end

		if removeItem then
			item:remove(1)
		end
	end
	return true
end

callback:register()
