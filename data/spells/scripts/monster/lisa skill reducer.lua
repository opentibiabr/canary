local combat = {}

for i = 60, 75 do
	combat[i] = Combat()
	combat[i]:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SMALLEARTH)

	local condition1 = Condition(CONDITION_ATTRIBUTES)
	condition1:setParameter(CONDITION_PARAM_TICKS, 7000)
	condition1:setParameter(CONDITION_PARAM_SKILL_MELEEPERCENT, i)
	condition1:setParameter(CONDITION_PARAM_SKILL_FISTPERCENT, i)
	condition1:setParameter(CONDITION_PARAM_SKILL_SHIELDPERCENT, i)

	local condition2 = Condition(CONDITION_ATTRIBUTES)
	condition2:setParameter(CONDITION_PARAM_TICKS, 7000)
	condition2:setParameter(CONDITION_PARAM_STAT_MAGICPOINTSPERCENT, i)

	local condition3 = Condition(CONDITION_ATTRIBUTES)
	condition3:setParameter(CONDITION_PARAM_TICKS, 7000)
	condition3:setParameter(CONDITION_PARAM_SKILL_DISTANCEPERCENT, i)
	condition3:setParameter(CONDITION_PARAM_SKILL_SHIELDPERCENT, i)

	arr = {
		{0, 0, 0, 1, 1, 1, 0, 0, 0},
		{0, 0, 1, 1, 1, 1, 1, 0, 0},
		{0, 1, 1, 1, 1, 1, 1, 1, 0},
		{1, 1, 1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 3, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1, 1, 1},
		{0, 1, 1, 1, 1, 1, 1, 1, 0},
		{0, 0, 1, 1, 1, 1, 1, 0, 0},
		{0, 0, 0, 1, 1, 1, 0, 0, 0}
	}

	local area = createCombatArea(arr)
	combat[i]:setArea(area)


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
					local player = Player(creatureTable[r])
					local vocationClientId = player:getVocation():getClientId()

					if isPlayer(creatureTable[r]) == true
					and table.contains({VOCATION.CLIENT_ID.SORCERER, VOCATION.CLIENT_ID.DRUID}, vocationClientId) then
						player:addCondition(condition2)
					elseif isPlayer(creatureTable[r]) == true
					and table.contains({VOCATION.CLIENT_ID.PALADIN}, vocationClientId) then
						player:addCondition(condition3)
					elseif isPlayer(creatureTable[r]) == true
					and table.contains({VOCATION.CLIENT_ID.KNIGHT}, vocationClientId) then
						player:addCondition(condition1)
					elseif isMonster(creatureTable[r]) == true then
					end
				end
			end
		end
		pos:sendMagicEffect(CONST_ME_SMALLPLANTS)
		return true
	end

	combat[i]:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

end

function onCastSpell(creature, var)
	return combat[math.random(60, 75)]:execute(creature, var)
end