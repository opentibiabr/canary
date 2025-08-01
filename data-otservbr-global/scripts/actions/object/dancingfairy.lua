local dancingfairy = Action()

local ORIGINAL_ID = 25747
local TRANSFORMED_ID = 25748
local REVERT_DELAY = 1 * 60 * 1000

function dancingfairy.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Doooon't touch me! *puff*")
	item:transform(TRANSFORMED_ID)

	local position = item:getPosition()

	addEvent(function(pos)
		local tile = Tile(pos)
		if not tile then
			return
		end

		for _, tileItem in ipairs(tile:getItems() or {}) do
			if tileItem:getId() == TRANSFORMED_ID then
				tileItem:transform(ORIGINAL_ID)
				player:addAchievementProgress("Fairy Teasing", 100)
				break
			end
		end
	end, REVERT_DELAY, position)

	return true
end

dancingfairy:id(ORIGINAL_ID)
dancingfairy:register()
