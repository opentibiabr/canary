local pick = Action()

local function revertItem(position, itemId, transformId)
	local item = Tile(position):getItemById(itemId)
	if item then
		item:transform(transformId)
	end
end

function pick.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Ice Islands Quest, Nibelor 1: Breaking the Ice
	if target:getActionId() == 60000 then
		local missionProgress, pickAmount = player:getStorageValue(Storage.Quest.U8_0.TheIceIslands.Questline), player:getStorageValue(Storage.Quest.U8_0.TheIceIslands.Mission02)
		if missionProgress < 1 or pickAmount >= 4 then
			return false
		end

		player:setStorageValue(Storage.Quest.U8_0.TheIceIslands.Mission02, math.max(0, pickAmount) + 1)

		if player:getStorageValue(Storage.Quest.U8_0.TheIceIslands.Mission02) == 4 then
			player:setStorageValue(Storage.Quest.U8_0.TheIceIslands.Questline, 4)
		end

		local crackItem = Tile(toPosition):getItemById(7185)
		if crackItem then
			crackItem:transform(7186)
			addEvent(revertItem, 60 * 1000, toPosition, 7186, 7185)
		end

		local chakoyas = {"Chakoya Toolshaper", "Chakoya Tribewarden", "Chakoya Windcaller"}
		Game.createMonster(chakoyas[math.random(#chakoyas)], toPosition)
		toPosition:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	return onUsePick(player, item, fromPosition, target, toPosition, isHotkey)
end

pick:id(3456)
pick:register()