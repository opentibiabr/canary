local function revertHorror()
	local melting = Tile(Position(32267, 31071, 14)):getTopCreature()
	local diference, pos, monster = 0, 0, false
	local specs, spec = Game.getSpectators(Position(32269, 31091, 14), false, false, 12, 12, 12, 12)
	for i = 1, #specs do
		spec = specs[i]
		if spec:isMonster() and spec:getName():lower() == 'melting frozen horror' then
			health = spec:getHealth()
			pos = spec:getPosition()
			spec:teleportTo(Position(32267, 31071, 14))
			diference = melting:getHealth() - health
			melting:addHealth( - diference)
			melting:teleportTo(pos)
			monster = true
		end
	end
	if not monster then
		if melting then
			melting:remove()
		end
	end
end

local function changeHorror()
	local melting = Tile(Position(32267, 31071, 14)):getTopCreature()
	local pos = 0
	local specs, spec = Game.getSpectators(Position(32269, 31091, 14), false, false, 12, 12, 12, 12)
	for i = 1, #specs do
		spec = specs[i]
		if spec:isMonster() and spec:getName():lower() == 'solid frozen horror' then
			pos = spec:getPosition()
			spec:teleportTo(Position(32267, 31071, 14))
			melting:teleportTo(pos)
		end
	end
	addEvent(revertHorror, 20 * 1000)
end

local dragonEggPrepareDeath = CreatureEvent("DragonEggPrepareDeath")
function dragonEggPrepareDeath.onPrepareDeath(creature, lastHitKiller, mostDamageKiller)
	if not creature:getName():lower() == "dragon egg" and creature:isMonster() then
		return true
	end
	creature:addHealth(1, false)
	return true
end
dragonEggPrepareDeath:register()

local dragonEggHealthChange = CreatureEvent("DragonEggHealthChange")
function dragonEggHealthChange.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if creature:getName():lower() == 'dragon egg' then
		if primaryType == COMBAT_HEALING then
			doTargetCombatHealth(0, creature, COMBAT_ICEDAMAGE, -primaryDamage, -primaryDamage, CONST_ME_MAGIC_GREEN)
			return true
		end
		if primaryType == COMBAT_FIREDAMAGE then
			primaryType = COMBAT_HEALING
			creature:addHealth(primaryDamage, true)
			if creature:getHealth() == creature:getMaxHealth() then
				creature:say('The egg sends out a fiery eruption!\n Weakening the frozen horror significantly!', TALKTYPE_MONSTER_SAY)
				doTargetCombatHealth(0, creature, COMBAT_ICEDAMAGE, -creature:getMaxHealth()/2, -creature:getMaxHealth()/2, CONST_ME_MAGIC_GREEN)
				changeHorror()
			end
			return true
		end
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end
dragonEggHealthChange:register()
