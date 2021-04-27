local function revertBone(position, itemId, transformId)
	local item = Tile(position):getItemById(itemId)
	if item then
			item:transform(transformId)
		end
end

local lowerRoshamuulBone = Action()
function lowerRoshamuulBone.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local rand = math.random(1, 100)
	if item.itemid == 22513 then
		if rand <= 20 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Amidst the pile of various bones you find  large, hollow part, similar to a pipe.')
			player:addItem(22389, 1)
			item:transform(11253, 22513)
			addEvent(revertBone, 120000, toPosition, 11253, 22513)
			toPosition:sendMagicEffect(3)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You ransack the pile but fail to find any useful parts.')
			item:transform(11253, 22513)
			addEvent(revertBone, 120000, toPosition, 11253, 22513)
			toPosition:sendMagicEffect(3)
			doSummonCreature("Guzzlemaw", toPosition)
		end
	end
end

lowerRoshamuulBone:id(22513)
lowerRoshamuulBone:register()