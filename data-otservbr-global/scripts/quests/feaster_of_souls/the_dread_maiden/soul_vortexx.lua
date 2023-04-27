local config = {
	["Blue Soul Stealer"] = {id = 32414, effect = CONST_ME_ICEATTACK, type = COMBAT_ICEDAMAGE},
	["Green Soul Stealer"] = {id = 32415, effect = CONST_ME_PLANTATTACK, type = COMBAT_EARTHDAMAGE},
	["Red Soul Stealer"] = {id = 32416, effect = CONST_ME_FIREAREA, type = COMBAT_FIREDAMAGE},
}
local area = createCombatArea(AREA_CIRCLE2X2)
local monsters = {"Blue Soul Stealer", "Green Soul Stealer", "Red Soul Stealer"}
local soulVortex = MoveEvent()

function soulVortex.onStepIn(creature, item, position, fromPosition)
	if creature:isPlayer() or creature:getMaster() then
		return true
	end
	local name = creature:getName()
	if not isInArray(monsters, name) then
		return true
	end
	local data = config[name]
	position:sendMagicEffect(CONST_ME_MORTAREA)
	local maiden = Creature("The Dread Maiden")
	if not maiden then
		return true
	end
	if data.id == item:getId() then
		local oldStorage = maiden:getStorageValue(Storage.Quest.FeasterOfSouls.Bosses.TheDreadMaiden.Souls)
		maiden:setStorageValue(Storage.Quest.FeasterOfSouls.Bosses.TheDreadMaiden.Souls, oldStorage + 1)
	else
		if math.random(2) == 2 then
			doAreaCombatHealth(creature, data.type, creature:getPosition(), area, -750, -1250, data.effect)
		else
			doTargetCombatHealth(0, maiden, COMBAT_HEALING, 3500, 5500, CONST_ME_NONE)
		end
	end
	creature:remove()
	return true
end

soulVortex:type("stepin")

for index, value in pairs(config) do
	soulVortex:id(value.id)
end

soulVortex:register()
