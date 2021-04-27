local vocation = {
	VOCATION.CLIENT_ID.SORCERER,
	VOCATION.CLIENT_ID.DRUID,
	VOCATION.CLIENT_ID.PALADIN,
	VOCATION.CLIENT_ID.KNIGHT
}

local condition = Condition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)
condition:setParameter(CONDITION_PARAM_SUBID, 88888)
condition:setParameter(CONDITION_PARAM_TICKS, 10 * 60 * 1000)
condition:setParameter(CONDITION_PARAM_HEALTHGAIN, 0.01)
condition:setParameter(CONDITION_PARAM_HEALTHTICKS, 10 * 60 * 1000)

local area = {
	{0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
	{0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
	{0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
	{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
	{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
	{1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1},
	{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
	{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
	{0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
	{0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
	{0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
}

local createArea = createCombatArea(area)

local combat = Combat()
combat:setArea(createArea)

function onTargetTile(creature, pos)
	local creatureTable = {}
	local n, i = Tile({x=pos.x, y=pos.y, z=pos.z}).creatures, 1
	if n ~= 0 then
		local v = getThingfromPos({x=pos.x, y=pos.y, z=pos.z, stackpos=i}).uid
		while v ~= 0 do
			if isCreature(v) == true then
				table.insert(creatureTable, v)
				if n == #creatureTable then
					break
				end
			end
			i = i + 1
			v = getThingfromPos({x=pos.x, y=pos.y, z=pos.z, stackpos=i}).uid
		end
	end
	if #creatureTable ~= nil and #creatureTable > 0 then
		for r = 1, #creatureTable do
			if creatureTable[r] ~= creature then
				local min = 1500
				local max = 1700
				local player = Player(creatureTable[r])

				if isPlayer(creatureTable[r]) == true and table.contains(vocation, player:getVocation():getClientId()) then
					doTargetCombatHealth(creature, creatureTable[r], COMBAT_FIREDAMAGE, -min, -max, CONST_ME_NONE)
				elseif isMonster(creatureTable[r]) == true then
					doTargetCombatHealth(creature, creatureTable[r], COMBAT_FIREDAMAGE, -min, -max, CONST_ME_NONE)
				end
			end
		end
	end
	pos:sendMagicEffect(CONST_ME_FIREAREA)
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

function onCastSpell(creature, var)
	if creature:getHealth() < creature:getMaxHealth() * 0.1 and not creature:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT, 88888) then
		creature:addCondition(condition)
		addEvent(delayedCastSpell, 5000, creature:getId(), var)
		creature:say("Better flee now.", TALKTYPE_ORANGE_1)
	else
		return
	end
	return true
end
