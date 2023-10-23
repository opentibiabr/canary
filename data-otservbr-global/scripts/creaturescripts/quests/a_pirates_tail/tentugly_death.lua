local tentuglysHeadDeath = CreatureEvent("TentuglysHeadDeath")

function tentuglysHeadDeath.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	if not creature or not creature:getMonster() then
		return
	end
	local damageMap = creature:getMonster():getDamageMap()

	for key, value in pairs(damageMap) do
		local player = Player(key)
		if player then
			player:setStorageValue(Storage.Quest.U12_60.APiratesTail.TentuglyKilled, 1) -- Access to wreckoning
			player:addAchievement("Release the Kraken")
			player:addMount(175)
		end
	end
end

tentuglysHeadDeath:register()
