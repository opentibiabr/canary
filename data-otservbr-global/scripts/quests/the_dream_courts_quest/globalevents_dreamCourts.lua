local templeEffects = {
	Position(32594, 32615, 9),
	Position(32595, 32614, 9),
	Position(32596, 32615, 9),
	Position(32597, 32615, 9),
	Position(32598, 32614, 9),
	Position(32599, 32614, 9),
	Position(32599, 32615, 9),
	Position(32600, 32615, 9),
	Position(32601, 32614, 9),
	Position(32602, 32615, 9),
	Position(32603, 32614, 9),
	Position(32604, 32614, 9),
	Position(32604, 32615, 9),
	Position(32605, 32615, 9),
	Position(32606, 32614, 9),
	Position(32606, 32615, 9),
	Position(32608, 32614, 9),
	Position(32608, 32615, 9),
	Position(32609, 32614, 9),
	Position(32611, 32615, 9),
	Position(32611, 32614, 9),
	Position(32610, 32615, 9),
	Position(32610, 32614, 9),
	Position(32616, 32615, 9),
	Position(32617, 32614, 9),
	Position(32618, 32614, 9),
	Position(32618, 32615, 9),
	Position(32619, 32615, 9),
}

local maxxeniusEffects = {
	fromPosition = Position(32200, 32041, 14),
	toPosition = Position(32217, 32057, 14),
	tileId = 9192,
}

local globalevents_dreamCourts = GlobalEvent("earthTrap")

function globalevents_dreamCourts.onThink(interval)
	local creature
	local chance = math.random(1, 10)
	local templeCenter = Position(32607, 32624, 9)
	local templeWatchers = Game.getSpectators(templeCenter, false, true, 20, 20, 20, 20)

	if #templeWatchers > 0 then
		for i = 1, #templeEffects do
			local position = templeEffects[i]
			position:sendMagicEffect(CONST_ME_SMALLPLANTS)
			creature = Tile(position):getTopCreature()
			if creature and creature:isPlayer() then
				doTargetCombatHealth(0, creature, COMBAT_EARTHDAMAGE, -(creature:getHealth() * 0.2), -(creature:getHealth() * 0.5), CONST_ME_SMALLPLANTS)
			end
		end
	end

	local maxxeniusCenter = Position(32208, 32048, 14)
	local maxxeniuswatchers = Game.getSpectators(maxxeniusCenter, false, true, 11, 11, 11, 11)

	if #maxxeniuswatchers > 0 then
		for x = maxxeniusEffects.fromPosition.x, maxxeniusEffects.toPosition.x do
			for y = maxxeniusEffects.fromPosition.y, maxxeniusEffects.toPosition.y do
				local sqm = Tile(Position(x, y, 14))

				if sqm:getItemById(maxxeniusEffects.tileId) then
					sqm:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)

					local min = -200
					local max = -600

					if sqm:getTopCreature() then
						if sqm:getTopCreature():isMonster() and sqm:getTopCreature():getName():lower() == "maxxenius" then
							min = -1111
							max = -3333
						end

						doTargetCombatHealth(0, sqm:getTopCreature(), COMBAT_ENERGYDAMAGE, min, max, CONST_ME_ENERGYHIT)
					end
				end
			end
		end
	end

	return true
end

globalevents_dreamCourts:interval(3000)
globalevents_dreamCourts:register()
