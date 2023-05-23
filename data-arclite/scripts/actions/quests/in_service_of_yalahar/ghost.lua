local config = {
	[8823] = 8824,
	[8824] = 8825,
	[8825] = 8859,
	[8859] = 8827
}

local inServiceYalaharGhost = Action()
function inServiceYalaharGhost.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local transformId = config[target.itemid]
	if not transformId then
		return true
	end

	for i = 1, 2 do
		Game.createMonster('Tormented Ghost', fromPosition)
	end

	local charmItem = Tile(Position(32776, 31062, 7)):getItemById(target.itemid)
	if charmItem then
		charmItem:transform(transformId)
	end

	toPosition:sendMagicEffect(CONST_ME_ENERGYHIT)
	item:remove()
	player:say('The ghost charm is charging.', TALKTYPE_MONSTER_SAY)

	if target.itemid == 8859 then
		player:setStorageValue(Storage.InServiceofYalahar.Questline, 37)
		player:setStorageValue(Storage.InServiceofYalahar.Mission06, 3) -- StorageValue for Questlog "Mission 06: Frightening Fuel"
		player:removeItem(8822, 1)
	end
	return true
end

inServiceYalaharGhost:id(8826)
inServiceYalaharGhost:register()