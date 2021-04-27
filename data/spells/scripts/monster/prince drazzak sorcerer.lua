local storage = 674531

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
				local min = 4000
				local max = 8000
				local player = Player(creatureTable[r])

				if isPlayer(creatureTable[r]) == true
				and table.contains({VOCATION.CLIENT_ID.CLIENT_ID.SORCERER}, player:getVocation():getClientId()) then
					doTargetCombatHealth(creature, creatureTable[r], COMBAT_DEATHDAMAGE, -min, -max, CONST_ME_NONE)
				elseif isMonster(creatureTable[r]) == true then
					doTargetCombatHealth(creature, creatureTable[r], COMBAT_DEATHDAMAGE, -min, -max, CONST_ME_NONE)
				end
			end
		end
	end
	pos:sendMagicEffect(CONST_ME_MORTAREA)
	return true
end

combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local function delayedCastSpell(cid, var)
	local creature = Creature(cid)
	if not creature then
		return
	end
	creature:say("DIE!", TALKTYPE_ORANGE_1)
	return combat:execute(creature, positionToVariant(creature:getPosition()))
end

function onCastSpell(creature, var)
local value = Game.getStorageValue(storage)
	if(os.time()-value >= 4) then
		creature:say("All SORCERERS must DIE!", TALKTYPE_ORANGE_1)
		addEvent(delayedCastSpell, 4000, creature:getId(), var)
		Game.setStorageValue(storage, os.time())
	end
	return true
end
