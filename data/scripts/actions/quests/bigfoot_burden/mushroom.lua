local function revertAid(position)
	local mushroom = Tile(position):getItemById(18220)
	if mushroom then
		mushroom:removeAttribute(ITEM_ATTRIBUTE_ACTIONID)
	end
end

local bigfootMushroom = Action()
function bigfootMushroom.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item:hasAttribute(ITEM_ATTRIBUTE_ACTIONID) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to wait to extract spores from this mushroom.")
		return true
	end

	local spore = Game.createItem(math.random(18221, 18224), 1, toPosition)
	if spore then
		spore:decay()
		item:setActionId(100)
		addEvent(revertAid, math.random(2,4) * 60 * 1000, toPosition)
	end
	return true
end

bigfootMushroom:id(18220)
bigfootMushroom:register()