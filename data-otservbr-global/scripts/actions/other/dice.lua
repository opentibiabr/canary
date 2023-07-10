local dice = Action()

function dice.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local dicePosition = item:getPosition()
	local value = math.random(6)
	local isInGhostMode = player:isInGhostMode()

	dicePosition:sendMagicEffect(CONST_ME_CRAPS, isInGhostMode and player)
	local spectators = Game.getSpectators(dicePosition, false, true, 3, 3)
	for i = 1, #spectators do
		player:say(player:getName() .. " rolled a " .. value .. ".", TALKTYPE_MONSTER_SAY, isInGhostMode, spectators[i], dicePosition)
	end
	item:transform(5791 + value)
	return true
end

dice:id(5792, 5793, 5794, 5795, 5796, 5797)
dice:register()
