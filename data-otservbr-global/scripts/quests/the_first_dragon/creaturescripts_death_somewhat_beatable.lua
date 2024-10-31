local deathSomewhatBeatable = CreatureEvent("SomewhatBeatableDeath")

function deathSomewhatBeatable.onDeath(creature, target)
	local spectators = Game.getSpectators(Position(33617, 31023, 14), false, false, 14, 14, 14, 14)
	for i = 1, #spectators do
		local spec = spectators[i]
		if spec:isPlayer() then
			if creature:getName():lower() == "somewhat beatable" then
				if spec:getStorageValue(Storage.Quest.U11_02.TheFirstDragon.SomewhatBeatable) < 5 then
					spec:setStorageValue(Storage.Quest.U11_02.TheFirstDragon.SomewhatBeatable, spec:getStorageValue(Storage.Quest.U11_02.TheFirstDragon.SomewhatBeatable) + 1)
				end
			end
			if spec:getStorageValue(Storage.Quest.U11_02.TheFirstDragon.SomewhatBeatable) == 5 then
				for b = 1, 6 do
					Game.createMonster("dragon essence", Position(math.random(33609, 33624), math.random(31017, 31028), 14), true, true)
				end
				spec:setStorageValue(Storage.Quest.U11_02.TheFirstDragon.SomewhatBeatable, 0)
			end
		end
	end
	return true
end

deathSomewhatBeatable:register()
