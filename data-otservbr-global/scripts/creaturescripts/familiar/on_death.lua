local familiarOnDeath = CreatureEvent("FamiliarDeath")

function familiarOnDeath.onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
	local player = creature:getMaster()
	if not player then
		return false
	end

	local vocation = FAMILIAR_ID[player:getVocation():getBaseId()]

	if table.contains(vocation, creature:getName()) then
		player:setStorageValue(Global.Storage.FamiliarSummon, os.time())
		for sendMessage = 1, #FAMILIAR_TIMER do
			stopEvent(player:getStorageValue(FAMILIAR_TIMER[sendMessage].storage))
			player:setStorageValue(FAMILIAR_TIMER[sendMessage].storage, -1)
		end
	end
	return true
end

familiarOnDeath:register()
