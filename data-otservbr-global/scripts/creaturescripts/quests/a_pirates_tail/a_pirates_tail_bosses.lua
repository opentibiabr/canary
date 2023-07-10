local tentuglysHeadDeath = CreatureEvent("TentuglysHeadDeath")

function tentuglysHeadDeath.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	local damageMap = creature:getMonster():getDamageMap()

	for key, value in pairs(damageMap) do
		local player = Player(key)
		if player and player:getStorageValue(Storage.Quest.U12_60.APiratesTail.TentuglyKilled) < 1 then
			player:setStorageValue(Storage.Quest.U12_60.APiratesTail.TentuglyKilled, 1) -- Access to wreckoning
			player:addMount(175)
		end
	end
end

tentuglysHeadDeath:register()
