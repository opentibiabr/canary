local partyProtection = CreatureEvent("PartyProtection")
local enabled = configManager.getBoolean(configKeys.ADVANCED_PARTY_PROTECTION)

local function getPlayerMaster(creature)
	if not creature then
		return nil
	end
	if creature:isPlayer() then
		return creature
	end
	if creature:isMonster() then
		local master = creature:getMaster()
		if master and master:isPlayer() then
			return master
		end
	end
	return nil
end

local function isSameParty(p1, p2)
	local party1 = p1:getParty()
	local party2 = p2:getParty()
	if not party1 or not party2 then
		return false
	end
	local leader1 = party1:getLeader()
	local leader2 = party2:getLeader()
	return leader1 and leader2 and leader1:getId() == leader2:getId()
end

function partyProtection.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not enabled then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	if not attacker then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	local sourcePlayer = getPlayerMaster(attacker)
	if not sourcePlayer then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	local targetPlayer = getPlayerMaster(creature)
	if not targetPlayer then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	if primaryType == COMBAT_HEALING or secondaryType == COMBAT_HEALING then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	if sourcePlayer:getId() == targetPlayer:getId() then
		return 0, primaryType, 0, secondaryType
	end

	if isSameParty(sourcePlayer, targetPlayer) then
		return 0, primaryType, 0, secondaryType
	end

	local targetSkull = targetPlayer:getSkull()
	if targetSkull == SKULL_NONE or targetSkull == SKULL_WHITE then
		local sourceSkull = sourcePlayer:getSkull()
		if sourceSkull == SKULL_NONE or sourceSkull == SKULL_WHITE then
			sourcePlayer:setSkull(SKULL_WHITE)
		end

		local condition = Condition(CONDITION_INFIGHT)
		condition:setTicks(60000)
		sourcePlayer:addCondition(condition)
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

partyProtection:register()
