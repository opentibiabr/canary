local attributes = TalkAction("/attr")

function attributes.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local position = player:getPosition()
	position:getNextPosition(player:getDirection())

	local tile = Tile(position)
	if not tile then
		player:sendTextMessage(MESSAGE_STATUS, "There is no tile in front of you.")
		return false
	end

	local thing = tile:getTopVisibleThing(player)
	if not thing then
		player:sendTextMessage(MESSAGE_STATUS, "There is an empty tile in front of you.")
		return false
	end

	local separatorPos = param:find(",")
	if not separatorPos then
		player:sendTextMessage(MESSAGE_STATUS, string.format("Usage: %s attribute, value.", words))
		return false
	end

	local attribute = string.trim(param:sub(0, separatorPos - 1))
	local value = string.trim(param:sub(separatorPos + 1))

	if thing:isItem() then
		local attributeId = Game.getItemAttributeByName(attribute)
		if attributeId == ITEM_ATTRIBUTE_NONE then
			player:sendTextMessage(MESSAGE_STATUS, "Invalid attribute name.")
			return false
		end

		if not thing:setAttribute(attribute, value) then
			player:sendTextMessage(MESSAGE_STATUS, "Could not set attribute.")
			return false
		end

		player:sendTextMessage(MESSAGE_STATUS, string.format("Attribute %s set to: %s", attribute, thing:getAttribute(attributeId)))
		position:sendMagicEffect(CONST_ME_MAGIC_GREEN)
	else
		player:sendTextMessage(MESSAGE_STATUS, "Thing in front of you is not supported.")
		return false
	end
	return true
end

attributes:separator(" ")
attributes:groupType("god")
attributes:register()
