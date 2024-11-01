local spiderName = "Lucifuga Aranea"

local function setActionId(itemid, position, aid)
	local item = Tile(position):getItemById(itemid)

	if item and item:getActionId() ~= aid then
		item:setActionId(aid)
	end
end

local movements_spiderSummon = MoveEvent()

function movements_spiderSummon.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()

	if not player then
		return true
	end

	if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.UnsafeRelease.HasBait) == 1 then
		local r = math.random(1, 10)
		Game.createMonster(spiderName, position)
		item:setActionId(0)
		addEvent(setActionId, r * (1000 * 60), item.itemid, position, 23120)
	end

	return true
end

movements_spiderSummon:aid(23120)
movements_spiderSummon:register()
