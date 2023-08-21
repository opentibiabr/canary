local fireBug = Action()

function fireBug.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local chance = math.random(10)
	if chance > 4 then
		if target.itemid == 182 then
			toPosition:sendMagicEffect(CONST_ME_HITBYFIRE)
			target:transform(188)
			target:decay()
		elseif target.itemid == 183 then
			toPosition:sendMagicEffect(CONST_ME_HITBYFIRE)
			target:transform(189)
			target:decay()
		elseif target.itemid == 5465 then
			toPosition:sendMagicEffect(CONST_ME_FIREAREA)
			target:transform(5464)
			target:decay()
		elseif target.itemid == 2114 then
			toPosition:sendMagicEffect(CONST_ME_HITBYFIRE)
			target:transform(2113)
		end -- It fails, but don't get removed 3% chance
	-- Success 6% chance
	-- Destroy spider webs/North - South
	-- Destroy spider webs/East - West
	-- Burn Sugar Cane
	-- Light up empty coal basins
	elseif chance == 2 then -- It removes the firebug 1% chance
		item:remove(1)
		toPosition:sendMagicEffect(CONST_ME_POFF)
	elseif chance == 1 then -- It explodes on the user 1% chance
		doTargetCombatHealth(0, player, COMBAT_FIREDAMAGE, -5, -5, CONST_ME_HITBYFIRE)
		player:say("OUCH!", TALKTYPE_MONSTER_SAY)
		item:remove(1)
	else
		toPosition:sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

fireBug:id(5467)
fireBug:register()
