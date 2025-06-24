local vocation = {
	VOCATION.BASE_ID.SORCERER,
	VOCATION.BASE_ID.DRUID,
	VOCATION.BASE_ID.PALADIN,
	VOCATION.BASE_ID.KNIGHT,
}

local area = {
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
	{ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
	{ 0, 1, 1, 1, 1, 3, 1, 1, 1, 1, 0 },
	{ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
	{ 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
}

local createArea = createCombatArea(area)

local combat = Combat()
combat:setArea(createArea)

function onTargetTile(creature, pos)
	local creatureTable = {}
	local n, i = Tile({ x = pos.x, y = pos.y, z = pos.z }).creatures, 1
	if n ~= 0 then
		local v = getThingfromPos({ x = pos.x, y = pos.y, z = pos.z, stackpos = i }).uid
		while v ~= 0 do
			local creatureFromPos = Creature(v)
			if creatureFromPos then
				table.insert(creatureTable, v)
				if n == #creatureTable then
					break
				end
			end
			i = i + 1
			v = getThingfromPos({ x = pos.x, y = pos.y, z = pos.z, stackpos = i }).uid
		end
	end

	if #creatureTable > 0 then
		local min = 1
		local max = 1
		for r = 1, #creatureTable do
			if creatureTable[r] ~= creature then
				local creatureInTable = Creature(creatureTable[r])
				if creatureInTable then
					if creatureInTable:isPlayer() and table.contains(vocation, creatureInTable:getVocation():getBaseId()) then
						doTargetCombatHealth(creature, creatureTable[r], COMBAT_ENERGYDAMAGE, -min, -max, CONST_ME_NONE)

						local currentStorage = creatureInTable:getStorageValue(65121)
						if currentStorage > 0 then
							local chance = math.random(1, 100)

							if chance <= 30 then
								creatureInTable:setStorageValue(65121, 0)
							end
						end
					elseif creatureInTable:isMonster() then
						doTargetCombatHealth(creature, creatureTable[r], COMBAT_ENERGYDAMAGE, -min, -max, CONST_ME_NONE)
					end
				end
			end
		end
	end
	pos:sendMagicEffect(54)
	return true
end

combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")
local function delayedCastSpell(cid, var)
	local creature = Creature(cid)
	if not creature then
		return
	end

	return combat:execute(creature, positionToVariant(creature:getPosition()))
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	addEvent(delayedCastSpell, 1000, creature:getId(), var)
	return true
end

spell:name("removepontos_vortex")
spell:words("###922")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()