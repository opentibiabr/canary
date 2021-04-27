local config = {
	[9738] = 9739,
	[9739] = 9740,
	[9740] = 9773,
	[9773] = 9742
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

	if target.itemid == 9773 then
		player:setStorageValue(Storage.InServiceofYalahar.Questline, 37)
		player:setStorageValue(Storage.InServiceofYalahar.Mission06, 3) -- StorageValue for Questlog "Mission 06: Frightening Fuel"
		player:removeItem(9737, 1)
	end
	return true
end

inServiceYalaharGhost:id(9741)
inServiceYalaharGhost:register()