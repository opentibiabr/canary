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
                local min = 4000
                local max = 6000
                local player = Player(creatureTable[r])

                if isPlayer(creatureTable[r]) == true and isInArray(voc, player:getVocation():getId()) then
                    doTargetCombatHealth(creature, creatureTable[r], COMBAT_FIREDAMAGE, -min, -max, CONST_ME_NONE)
                elseif isMonster(creatureTable[r]) == true then
                    doTargetCombatHealth(creature, creatureTable[r], COMBAT_FIREDAMAGE, -min, -max, CONST_ME_NONE)
                end
            end
        end
    end
    pos:sendMagicEffect(CONST_ME_FIREAREA)
	creature:remove()
    return true
end

combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local function delayedCastSpell(cid, var)
    local creature = Creature(cid)
	if not creature then
		return
	end
	if creature:getHealth() >= 1 then
		local master = creature:getMaster()
		master:addHealth(math.random(20000, 30000), true, true)
		Game.createMonster('demon', creature:getPosition(), true, true)
		return combat:execute(creature, positionToVariant(creature:getPosition()))
	end
	return
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
    addEvent(delayedCastSpell, 7000, creature:getId(), var)
    return true
end

spell:name("eruption of destruction explosion")
spell:words("###164")
spell:needTarget(false)
spell:needLearn(true)
spell:isAggressive(true)
spell:blockWalls(true)
spell:register()
