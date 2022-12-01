local fount = {
	[1] = {transformid = 22166, pos = Position(33421, 32383, 12), revert = 2094},
	[2] = {transformid = 22167, pos = Position(33422, 32383, 12), revert = 2095},
	[3] = {transformid = 22168, pos = Position(33421, 32384, 12), revert = 2096},
	[4] = {transformid = 22169, pos = Position(33422, 32384, 12), revert = 2097}
}

local ferumbrasAscendantStatue = Action()
function ferumbrasAscendantStatue.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if Tile(Position(33415, 32379, 12)):getItemById(22163) or player:getStorageValue(Storage.FerumbrasAscension.Fount) < 4 or player:getStorageValue(Storage.FerumbrasAscension.Statue) >= 1 then
		return false
	end
	for i = 1, #fount do
		local fount = fount[i]
		local founts = Tile(fount.pos):getItemById(fount.transformid)
		founts:transform(fount.revert)
		founts:setActionId(53805)
	end
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You douse the sacred statue\'s flame. The room darkens.')
	player:setStorageValue(Storage.FerumbrasAscension.Statue, 1)
	item:transform(22163)
	return true
end

ferumbrasAscendantStatue:id(22161)
ferumbrasAscendantStatue:register()