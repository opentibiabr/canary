local die = Action()

function die.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local position = item:getPosition()
	local value = math.random(1, 6)
	local isInGhostMode = player:isInGhostMode()

	if not isInGhostMode then
		player:getPosition():sendMagicEffect(CONST_ME_CRAPS)

		local spectators = Game.getSpectators(position, false, true, 3, 3)
		for _, spectator in ipairs(spectators) do
			player:say(player:getName() .. " rolled a " .. value .. ".", TALKTYPE_MONSTER_SAY, isInGhostMode, spectator, position)
		end
	end

	if value == 6 then
		player:kv():set("die-rolled-six", player:kv():get("die-rolled-six") + 1)

		if player:kv():get("die-rolled-six") == 3 then
			player:addAchievement("Number of the Beast")
		end
	else
		player:kv():remove("die-rolled-six")
	end

	item:transform(5791 + value)
	return true
end

for items = 5792, 5797 do
	die:id(items)
end

die:register()
