local fires = {
	[2040] = {vocationId = VOCATION.CLIENT_ID.SORCERER, damage = 300},
	[2041] = {vocationId = VOCATION.CLIENT_ID.SORCERER, damage = 600},
	[2042] = {vocationId = VOCATION.CLIENT_ID.SORCERER, damage = 1200},
	[2043] = {vocationId = VOCATION.CLIENT_ID.SORCERER, damage = 2400},
	[2044] = {vocationId = VOCATION.CLIENT_ID.SORCERER, damage = 3600},
	[2045] = {vocationId = VOCATION.CLIENT_ID.SORCERER, damage = 7200},
	[2046] = {vocationId = VOCATION.CLIENT_ID.DRUID, damage = 300},
	[2047] = {vocationId = VOCATION.CLIENT_ID.DRUID, damage = 600},
	[2048] = {vocationId = VOCATION.CLIENT_ID.DRUID, damage = 1200},
	[2049] = {vocationId = VOCATION.CLIENT_ID.DRUID, damage = 2400},
	[2050] = {vocationId = VOCATION.CLIENT_ID.DRUID, damage = 3600},
	[2051] = {vocationId = VOCATION.CLIENT_ID.DRUID, damage = 7200},
	[2052] = {vocationId = VOCATION.CLIENT_ID.PALADIN, damage = 300},
	[2053] = {vocationId = VOCATION.CLIENT_ID.PALADIN, damage = 600},
	[2054] = {vocationId = VOCATION.CLIENT_ID.PALADIN, damage = 1200},
	[2055] = {vocationId = VOCATION.CLIENT_ID.PALADIN, damage = 2400},
	[2056] = {vocationId = VOCATION.CLIENT_ID.PALADIN, damage = 3600},
	[2057] = {vocationId = VOCATION.CLIENT_ID.PALADIN, damage = 7200},
	[2058] = {vocationId = VOCATION.CLIENT_ID.KNIGHT, damage = 300},
	[2059] = {vocationId = VOCATION.CLIENT_ID.KNIGHT, damage = 600},
	[2060] = {vocationId = VOCATION.CLIENT_ID.KNIGHT, damage = 1200},
	[2061] = {vocationId = VOCATION.CLIENT_ID.KNIGHT, damage = 2400},
	[2062] = {vocationId = VOCATION.CLIENT_ID.KNIGHT, damage = 3600},
	[2063] = {vocationId = VOCATION.CLIENT_ID.KNIGHT, damage = 7200}
}

local fireTile = MoveEvent()

function fireTile.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local fire = fires[item.actionid]
	if not fire then
		return true
	end

	if player:getVocation():getClientId() == fire.vocationId then
		doTargetCombatHealth(0, player, COMBAT_FIREDAMAGE, -300, -300, CONST_ME_HITBYFIRE)
	else
		local combatType = COMBAT_FIREDAMAGE
		if fire.damage > 300 then
			combatType = COMBAT_PHYSICALDAMAGE
		end
		doTargetCombatHealth(0, player, combatType, -fire.damage, -fire.damage, CONST_ME_FIREATTACK)
	end
	return true
end

fireTile:type("stepin")

for index, value in pairs(fires) do
	fireTile:aid(index)
end

fireTile:register()
