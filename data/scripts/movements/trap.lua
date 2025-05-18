local trapsOnStepIn = {
	[2145] = { transformTo = 2146, damage = nil },
	[2146] = { transformTo = nil, damage = { -50, -100 } },
	[2147] = { transformTo = 2148, damage = nil },
	[2148] = { transformTo = nil, damage = { -50, -100 } },
	[3482] = { transformTo = 3481, damage = { -15, -30 }, ignorePlayer = (Game.getWorldType() == WORLD_TYPE_NO_PVP) },
	[3944] = { transformTo = 3945, damage = { -15, -30 }, type = COMBAT_EARTHDAMAGE },
	[12368] = { transformTo = nil, damage = nil, ignorePlayer = true },
}

local trapEvent = MoveEvent()

function trapEvent.onStepIn(creature, item, position, fromPosition)
	local trap = trapsOnStepIn[item.itemid]
	if not trap then
		return true
	end

	local tile = Tile(position)
	if not tile then
		return true
	end

	if tile:hasFlag(TILESTATE_PROTECTIONZONE) then
		return true
	end

	if tile:getItemCountById(3482) > 1 then
		return true
	end

	if trap.ignorePlayer and creature:isPlayer() then
		return true
	end

	if trap.transformTo then
		item:transform(trap.transformTo)
	end

	if item.itemid == 12368 and creature:getName() == "Starving Wolf" then
		position:sendMagicEffect(CONST_ME_STUN)
		creature:remove()
		Game.createItem(12369, 1, position)
		return true
	end

	-- A trap can deal damage or the transformed item can deal damage
	if trap.damage then
		doTargetCombatHealth(0, creature, trap.type or COMBAT_PHYSICALDAMAGE, trap.damage[1], trap.damage[2], CONST_ME_NONE)
		return true
	end

	trap = trapsOnStepIn[item.itemid]
	if trap and trap.damage then
		doTargetCombatHealth(0, creature, trap.type or COMBAT_PHYSICALDAMAGE, trap.damage[1], trap.damage[2], CONST_ME_NONE)
	end
	return true
end

trapEvent:type("stepin")
for itemId, _ in pairs(trapsOnStepIn) do
	trapEvent:id(itemId)
end
trapEvent:register()

local trapsOnStepOut = {
	[2146] = {},
	[2148] = {},
	[3945] = { secondsInterval = 20, positions = {} },
}

trapEvent = MoveEvent()

function trapEvent.onStepOut(creature, item, position, fromPosition)
	local tile = Tile(position)
	if not tile then
		return true
	end

	if tile:hasFlag(TILESTATE_PROTECTIONZONE) then
		return true
	end

	local trap = trapsOnStepOut[item.itemid]
	if trap and trap.secondsInterval then
		-- trap.secondsInterval determines how long after
		-- the trap re-arms
		if not trap.positions[position:toString()] then
			trap.positions[position:toString()] = true
			addEvent(function()
				trap.positions[position:toString()] = nil
				if item then
					item:transform(item:getId() - 1)
				end
			end, trap.secondsInterval * 1000)
		end
		return true
	end

	item:transform(item.itemid - 1)
	return true
end

trapEvent:type("stepout")
for itemId, _ in pairs(trapsOnStepOut) do
	trapEvent:id(itemId)
end
trapEvent:register()

trapEvent = MoveEvent()

function trapEvent.onRemoveItem(item, position)
	local itemPosition = item:getPosition()
	if itemPosition:getDistance(position) > 0 then
		item:transform(item.itemid - 1)
		itemPosition:sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

trapEvent:type("removeitem")
trapEvent:id(3482)
trapEvent:register()
