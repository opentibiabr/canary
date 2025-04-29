local function transformBack(position, itemId, transformId)
	local item = Tile(position):getItemById(itemId)
	if item then
		item:transform(transformId)
		position:sendMagicEffect(CONST_ME_MAGIC_GREEN)
	end
end

local icePaint = Action()
function icePaint.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 7178 then
		return false
	end

	if player:getStorageValue(Storage.Quest.U8_0.TheIceIslands.Questline) == 8 then
		toPosition:sendMagicEffect(CONST_ME_GREEN_RINGS)
		player:setStorageValue(Storage.Quest.U8_0.TheIceIslands.PaintSeal, player:getStorageValue(Storage.Quest.U8_0.TheIceIslands.PaintSeal) + 1)
		if player:getStorageValue(Storage.Quest.U8_0.TheIceIslands.PaintSeal) == 2 then
			player:setStorageValue(Storage.Quest.U8_0.TheIceIslands.Questline, 9)
			player:setStorageValue(Storage.Quest.U8_0.TheIceIslands.Mission04, 2) -- Questlog The Ice Islands Quest, Nibelor 3: Artful Sabotage
			player:removeItem(7253, 1)
			if player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.TortoiseEggNargorDoor) >= 2 then
				player:addAchievement("Animal Activist")
			end
		end
		player:say("You painted a baby seal.", TALKTYPE_MONSTER_SAY)
		target:transform(7252)
		addEvent(transformBack, 30 * 1000, toPosition, 7252, 7178)
	end
	return true
end

icePaint:id(7253)
icePaint:register()
