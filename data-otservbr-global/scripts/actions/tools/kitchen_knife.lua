local kitchenKnife = Action()

local function revertItem(position, itemId, transformId)
	local item = Tile(position):getItemById(itemId)
	if item then
		item:transform(transformId)
	end
end

function kitchenKnife.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target:isItem() then
		return false
	end

	local targetId = target:getId()

	--The Ice Islands Quest - Cure the Dogs
	if targetId == 7261 then
		if player:getStorageValue(Storage.Quest.U8_0.TheIceIslands.Questline) >= 21 then
			if player:getStorageValue(Storage.Quest.U8_0.TheIceIslands.FrostbiteHerb) < 1 then
				player:addItem(7248, 1)
				player:setStorageValue(Storage.Quest.U8_0.TheIceIslands.FrostbiteHerb, 1)
				toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:say('You cut a leaf from a frostbite herb.', TALKTYPE_MONSTER_SAY)
			end
		end
	elseif targetId == 3647 then
		if player:getStorageValue(Storage.Quest.U8_0.TheIceIslands.Questline) >= 21 then
			if player:getStorageValue(Storage.Quest.U8_0.TheIceIslands.FlowerCactus) < 1 then
				player:addItem(7245, 1)
				player:setStorageValue(Storage.Quest.U8_0.TheIceIslands.FlowerCactus, 1)
				target:transform(3646)
				addEvent(revertItem, 60 * 1000, toPosition, 3646, 3647)
				toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
				player:say('You cut a flower from a cactus.', TALKTYPE_MONSTER_SAY)
			end
		end
	elseif targetId == 3753 then
		if player:getStorageValue(Storage.Quest.U8_0.TheIceIslands.Questline) >= 21 then
			if player:getStorageValue(Storage.Quest.U8_0.TheIceIslands.FlowerBush) < 1 then
				player:addItem(7249, 1)
				player:setStorageValue(Storage.Quest.U8_0.TheIceIslands.FlowerBush, 1)
				target:transform(3750)
				addEvent(revertItem, 60 * 1000, toPosition, 3750, 3753)
				toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
				player:say('You cut a flower from a bush.', TALKTYPE_MONSTER_SAY)
			end
		end
	end

	return onUseKitchenKnife(player, item, fromPosition, target, toPosition, isHotkey)
end

kitchenKnife:id(3469)
kitchenKnife:register()