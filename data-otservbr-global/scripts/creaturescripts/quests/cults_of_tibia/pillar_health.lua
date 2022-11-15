local defensor = {
	["eshtaba the conjurer"] = Position(33093, 31919, 15),
	["dorokoll the mystic"] = Position(33095, 31925, 15),
	["mezlon the defiler"] = Position(33101, 31925, 15),
	["eliz the unyielding"] = Position( 33103, 31919, 15),
	["malkhar deathbringer"] = Position(33098, 31915, 15),
}

local healthPillar = CreatureEvent("HealthPillar")
function healthPillar.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not creature:isMonster() then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	local monster = defensor[creature:getName():lower()]
	local protector = 'pillar of'
	if monster then
		local pMonster = Tile(Position(monster)):getTopCreature()
		if not pMonster then
			return primaryDamage, primaryType, secondaryDamage, secondaryType
		end
		if pMonster:getName():lower():find(protector) then
			primaryDamage = 0
			secondaryDamage = 0
		end
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

healthPillar:register()
