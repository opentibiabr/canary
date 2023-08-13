local removeThing = TalkAction("/r")

function removeThing.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local position = player:getPosition()
	position:getNextPosition(player:getDirection())

	local tile = Tile(position)
	if not tile then
		player:sendCancelMessage("Object not found.")
		return true
	end

	local thing = tile:getTopVisibleThing(player)
	if not thing then
		player:sendCancelMessage("Thing not found.")
		return true
	end

	if thing:isCreature() then
		thing:remove()
	elseif thing:isItem() then
		if thing == tile:getGround() then
			player:sendCancelMessage("You may not remove a ground tile.")
			return true
		end
		thing:remove(tonumber(param) or -1)
	end

	position:sendMagicEffect(CONST_ME_MAGIC_RED)
	return true
end

removeThing:separator(" ")
removeThing:groupType("god")
removeThing:register()
