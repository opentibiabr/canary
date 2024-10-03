local mirror = Action()

local function revertItem(position, itemId)
	local item = Tile(position):getItemById(itemId)
	if item then
		item:transform(itemId)
	end
end

function mirror.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U8_1.ToBlindTheEnemy.Questline) == 1 then
		if target:getActionId() == 4001 and target.itemid == 132 then
			local itemToRemove = Tile(toPosition):getItemById(132)
			if itemToRemove then
				itemToRemove:remove()
				toPosition:sendMagicEffect(CONST_ME_MAGIC_POWDER)
				player:setStorageValue(Storage.Quest.U8_1.ToBlindTheEnemy.Questline, 2)
				player:say("KABOOM !!", TALKTYPE_MONSTER_SAY, false, player, toPosition)
				addEvent(revertItem, 60 * 1000, toPosition, 132)
				item:remove(1)
			end

			return true
		end
	end

	return onUseMirror(player, item, fromPosition, target, toPosition, isHotkey)
end

mirror:id(3463)
mirror:register()
