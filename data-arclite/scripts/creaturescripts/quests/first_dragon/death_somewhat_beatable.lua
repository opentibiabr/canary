local deathSomewhatBeatable = CreatureEvent("Somewhat Beatable Death")

function deathSomewhatBeatable.onDeath(creature, target)
	local spectators = Game.getSpectators(Position(33617, 31023, 14), false, false, 14, 14, 14, 14)
		for i = 1, #spectators do
			local spec = spectators[i]
			if spec:isPlayer() then
				if creature:getName():lower() == "somewhat beatable" then
					if spec:getStorageValue(Storage.FirstDragon.SomewhatBeatable) < 5 then
						spec:setStorageValue(Storage.FirstDragon.SomewhatBeatable, spec:getStorageValue(Storage.FirstDragon.SomewhatBeatable) + 1)
					end
				end
				if spec:getStorageValue(Storage.FirstDragon.SomewhatBeatable) == 5 then
					for b = 1, 6 do
						Game.createMonster('Dragon Essence', Position(math.random(33609, 33624), math.random(31017, 31028), 14), true, true)
					end
					spec:setStorageValue(Storage.FirstDragon.SomewhatBeatable, 0)
				end
			end
		end
	return true
end

deathSomewhatBeatable:register()
