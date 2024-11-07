local amberCrusher = Action()

function amberCrusher.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or not target:isItem() or target:getId() == item:getId() or player:getItemCount(target:getId()) <= 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can only use the crusher on a valid gem in your inventory.")
		return false
	end

	local fragmentType, fragmentRange = getGemData(target:getId())
	if not fragmentType then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This item can't be broken into fragments.")
		return false
	end

	if target:getCount() >= MAX_GEM_BREAK then
		target:remove(MAX_GEM_BREAK)
		for i = 1, MAX_GEM_BREAK, 1 do
			player:addItem(fragmentType, math.random(fragmentRange[1], fragmentRange[2]))
		end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have broken the gems into fragments.")
	else
		target:remove(1)
		player:addItem(fragmentType, math.random(fragmentRange[1], fragmentRange[2]))
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have broken the gem into fragments.")
	end

	return true
end

amberCrusher:id(46628)
amberCrusher:register()
