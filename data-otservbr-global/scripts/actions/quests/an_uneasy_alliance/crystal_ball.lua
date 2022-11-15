local function revert(position)
	local crystal = Tile(position):getItemById(10187)
	if crystal then
		crystal:transform(10186)
	end
end

local AnUneasyAlliance = Storage.Quest.U8_54.AnUneasyAlliance
local crystalball = Action()

function crystalball.onUse(player, item, fromPosition, target, toPosition)
	if Tile(toPosition):getItemById(10187) then
		return true
	end
	if player:getStorageValue(AnUneasyAlliance.Questline) == 3 then
		Tile(toPosition):getItemById(10186):transform(10187)
		toPosition:sendMagicEffect(CONST_ME_ENERGYHIT)
		addEvent(revert, 10 * 1000, toPosition) -- 10 sec
		player:setStorageValue(AnUneasyAlliance.Questline, 4)
	end
	return true
end

crystalball:aid(40030)
crystalball:register()
