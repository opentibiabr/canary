local mage = {1, 2, 5, 6}
local paladin = {3, 7}
local knight = {4, 8}

local combat = {}

for i = 45, 60 do
	combat[i] = Combat()

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

	local area = createCombatArea(AREA_CIRCLE3X3)
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

                if isPlayer(creatureTable[r]) == true and isInArray(mage, player:getVocation():getId()) then
				    player:addCondition(condition2)
				elseif isPlayer(creatureTable[r]) == true and isInArray(paladin, player:getVocation():getId()) then
				    player:addCondition(condition3)
				elseif isPlayer(creatureTable[r]) == true and isInArray(knight, player:getVocation():getId()) then
				    player:addCondition(condition1)
				elseif isMonster(creatureTable[r]) == true then
				end
            end
        end
    end
    pos:sendMagicEffect(CONST_ME_MAGIC_RED)
    return true
end

combat[i]:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat[math.random(45, 60)]:execute(creature, var)
end

spell:name("walker skill reducer")
spell:words("###144")
spell:needTarget(false)
spell:needLearn(true)
spell:isAggressive(true)
spell:blockWalls(true)
spell:register()
