local bonusCountPercent = 3

local preyLootBonusKill = CreatureEvent("PreyLootBonusKill")

function preyLootBonusKill.onKill(player, target, lastHit)
	-- Monster verify
	if not target or not target:isMonster() or target:getMaster() then
		return true
	end

	local mType = target:getType()
	
	local preyLootPercent = player:getPreyLootPercentage(mType:raceId())
	if preyLootPercent > 0 and probability < preyLootPercent then
		target:registerEvent('BonusPreyLootDeath')
	end
	return true
end

preyLootBonusKill:register()

local bonusPreyLootDeath = CreatureEvent("BonusPreyLootDeath")
function bonusPreyLootDeath.onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
	if not creature then
		return true
	end
	local monsterLoot = creature:getType():getLoot()
  local mType = creature:getType()
	if not mType:getLoot() or not corpse then
		return true
	end

	for i, loot in pairs(monsterLoot) do
		local item = corpse:createLootItem(monsterLoot[i], false)
		if not item then
			Spdlog.warn(string.format("[bonusPreyLootDeath.onDeath] - Could not add loot item to monster: %s, from corpse id: %d.", self:getName(), corpse:getId()))
		end
	end
	return true
end

bonusPreyLootDeath:register()
