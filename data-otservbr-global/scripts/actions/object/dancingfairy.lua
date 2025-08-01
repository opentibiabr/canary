local dancingfairy = Action()

local ORIGINAL_ID = 25747
local TRANSFORMED_ID = 25748
local REVERT_DELAY = 1 * 60 * 1000

function dancingfairy.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not item or item:getId() ~= ORIGINAL_ID then
		return false
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Doooon't touch me! *puff*")
	item:transform(TRANSFORMED_ID)

	local position = item:getPosition()
	local playerId = player:getId()

	addEvent(function(pos, pid)
		local tile = Tile(pos)
		local player = Player(pid)
		if not tile or not player then
			return
		end

		local transformedItem = tile:getItemById(TRANSFORMED_ID)
		if transformedItem then
			transformedItem:transform(ORIGINAL_ID)
			player:addAchievementProgress("Fairy Teasing", 100)
		end
	end, REVERT_DELAY, position, playerId)

	return true
end

dancingfairy:id(ORIGINAL_ID)
dancingfairy:register()
