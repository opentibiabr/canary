local voc = {1, 2, 3, 4, 5, 6, 7, 8}

	arr = {
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

local area = createCombatArea(arr)

local combat = Combat()
combat:setArea(area)

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
                local min = 30000
                local max = 30000
                local player = Player(creatureTable[r])

                if isPlayer(creatureTable[r]) == true and isInArray(voc, player:getVocation():getId()) then
                    doTargetCombatHealth(creature, creatureTable[r], COMBAT_ENERGYDAMAGE, -min, -max, CONST_ME_NONE)
                elseif isMonster(creatureTable[r]) == true then
                    doTargetCombatHealth(creature, creatureTable[r], COMBAT_ENERGYDAMAGE, -min, -max, CONST_ME_NONE)
                end
            end
        end
    end
    pos:sendMagicEffect(CONST_ME_PURPLEENERGY)
    return true
end

combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local function delayedCastSpell(cid, var)
    local creature = Creature(cid)
	if not creature then
		return
	end
	creature:say("Gaz'haragoth calls down: DEATH AND DOOM!", TALKTYPE_ORANGE_2)
	return combat:execute(creature, positionToVariant(creature:getPosition()))
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
    creature:say("Gaz'haragoth begins to channel DEATH AND DOOM into the area! RUN!", TALKTYPE_ORANGE_2)
    addEvent(delayedCastSpell, 5000, creature:getId(), var)
    return true
end

spell:name("gaz'haragoth death")
spell:words("###113")
spell:needTarget(false)
spell:needLearn(true)
spell:isAggressive(true)
spell:blockWalls(true)
spell:register()
