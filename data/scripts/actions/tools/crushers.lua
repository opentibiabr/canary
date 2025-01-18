local config = {
	maxGemBreak = 10,
	fragmentGems = {
		small = { ids = { 44602, 44605, 44608, 44611 }, fragment = 46625, range = { 1, 4 } },
		medium = { ids = { 44603, 44606, 44609, 44612 }, fragment = 46625, range = { 2, 8 } },
		great = { ids = { 44604, 44607, 44610, 44613 }, fragment = 46626, range = { 1, 4 } },
	},
}

local function getGemData(gemId)
	for _, gemData in pairs(config.fragmentGems) do
		if table.contains(gemData.ids, gemId) then
			return gemData.fragment, gemData.range
		end
	end
	return nil
end

local amberCrusher = Action()

function amberCrusher.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or not target:isItem() or target:getId() == item:getId() or player:getItemCount(target:getId()) <= 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can only use the crusher on a valid gem in your inventory.")
		return true
	end

	local fragmentType, fragmentRange = getGemData(target:getId())
	if not fragmentType then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This item can't be broken into fragments.")
		return true
	end

	local breakAmount = (target:getCount() >= config.maxGemBreak) and config.maxGemBreak or 1
	target:remove(breakAmount)

	for _ = 1, breakAmount do
		player:addItem(fragmentType, math.random(fragmentRange[1], fragmentRange[2]))
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have broken the gem into fragments.")
	return true
end

amberCrusher:id(46628)
amberCrusher:register()

local crusher = Action()

function crusher.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or not target:isItem() or target:getId() == item:getId() or player:getItemCount(target:getId()) <= 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can only use the crusher on a valid gem in your inventory.")
		return true
	end

	local fragmentType, fragmentRange = getGemData(target:getId())
	if not fragmentType then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This item can't be broken into fragments.")
		return true
	end

	local crusherCharges = item:getAttribute(ITEM_ATTRIBUTE_CHARGES)
	if not crusherCharges or crusherCharges <= 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your crusher has no more charges.")
		return true
	end

	target:remove(1)
	player:addItem(fragmentType, math.random(fragmentRange[1], fragmentRange[2]))
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have broken the gem into fragments.")

	crusherCharges = crusherCharges - 1
	if crusherCharges > 0 then
		local container = item:getParent()
		item:setAttribute(ITEM_ATTRIBUTE_CHARGES, crusherCharges)
		if container:isContainer() then
			player:sendUpdateContainer(container)
		end
	else
		item:remove()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your crusher has been consumed.")
	end
	return true
end

crusher:id(46627)
crusher:register()
