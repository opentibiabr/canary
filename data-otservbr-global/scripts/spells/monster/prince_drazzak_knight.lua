local storage = 674531

local area = createCombatArea(AREA_CIRCLE3X3)

local combat = Combat()
combat:setArea(area)

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
	if #creatureTable ~= nil and #creatureTable > 0 then
		for r = 1, #creatureTable do
			if creatureTable[r] ~= creature then
				local min = 4000
				local max = 8000
				local creatureTarget = Creature(creatureTable[r])
				if creatureTarget then
					if (creatureTarget:isPlayer() and table.contains({ VOCATION.BASE_ID.KNIGHT }, creatureTarget:getVocation():getBaseId())) or creatureTarget:isMonster() then
						doTargetCombatHealth(creature, creatureTarget, COMBAT_FIREDAMAGE, -min, -max, CONST_ME_NONE)
					end
				end
			end
		end
	end
	pos:sendMagicEffect(CONST_ME_HITBYFIRE)
	return true
end

combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local function delayedCastSpell(cid, var)
	local creature = Creature(cid)
	if not creature then
		return
	end
	creature:say("DIE!", TALKTYPE_MONSTER_SAY)
	return combat:execute(creature, positionToVariant(creature:getPosition()))
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local value = Game.getStorageValue(storage)
	if os.time() - value >= 4 then
		creature:say("All KNIGHTS must DIE!", TALKTYPE_MONSTER_SAY)
		addEvent(delayedCastSpell, 4000, creature:getId(), var)
		Game.setStorageValue(storage, os.time())
	end
	return true
end

spell:name("prince drazzak knight")
spell:words("###320")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
