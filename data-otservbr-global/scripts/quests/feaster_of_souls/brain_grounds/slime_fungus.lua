local damages = {
	[8] = 0.000019,
	[9] = 0.000030,
	[10] = 0.000035,
}

local damage_chance = 3000

local fromPos, toPos = Position({x = 31900, y = 32281, z = 8}), Position({x = 32022, y = 32365, z = 10})

local slimeFungus = MoveEvent()

function slimeFungus.onStepIn(creature, item, position, fromPosition)
	if not isInRange(position, fromPos, toPos) then
		return true
	end
	local master = creature:getMaster()
	if creature:isPlayer() or (master and master:isPlayer()) then
		local storage = master and master:getStorageValue(Storage.Quest.FeasterOfSouls.Bosses.BrainHead.Killed) or creature:getStorageValue(Storage.Quest.FeasterOfSouls.Bosses.BrainHead.Killed)
		if storage == -1 then
			if math.random(1, 100000) <= damage_chance then
				creature:addHealth(-(creature:getMaxHealth() * damages[position.z]), COMBAT_EARTHDAMAGE)
				position:sendMagicEffect(CONST_ME_CARNIPHILA)
			end
		end
	end
	return true
end

slimeFungus:type("stepin")

for i=12083, 12355 do
	slimeFungus:id(i)
end

slimeFungus:register()
