local fount = {
	[1] = {transformid = 24822, pos = Position(33421, 32383, 12), revert = 3729},
	[2] = {transformid = 24823, pos = Position(33422, 32383, 12), revert = 3730},
	[3] = {transformid = 24824, pos = Position(33421, 32384, 12), revert = 3731},
	[4] = {transformid = 24825, pos = Position(33422, 32384, 12), revert = 3732}
}

local ferumbrasAscendantSacrifice = Action()
function ferumbrasAscendantSacrifice.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target.actionid == 53805 or Tile(Position(33415, 32379, 12)):getItemById(24817) or player:getStorageValue(Storage.FerumbrasAscension.Fount) >= 4 then
		return false
	end
	if item.itemid == 24814 then
		if player:getStorageValue(Storage.FerumbrasAscension.Bone) >= 1 then
			player:say('You already put the bones on the blood well.', TALKTYPE_MONSTER_SAY)
			return true
		end
		player:setStorageValue(Storage.FerumbrasAscension.Bone, 1)
	elseif item.itemid == 24826 then
		if player:getStorageValue(Storage.FerumbrasAscension.Ring2) >= 1 then
			player:say('You already put the signet ring on the blood well.', TALKTYPE_MONSTER_SAY)
			return true
		end
		player:setStorageValue(Storage.FerumbrasAscension.Ring2, 1)
	elseif item.itemid == 10602 then
		if player:getStorageValue(Storage.FerumbrasAscension.Vampire) >= 1 then
			player:say('You already put the vampire teeth on the blood well.', TALKTYPE_MONSTER_SAY)
			return true
		end
		player:setStorageValue(Storage.FerumbrasAscension.Vampire, 1)
	elseif item.itemid == 2747 then
		if player:getStorageValue(Storage.FerumbrasAscension.Flower) >= 1 then
			player:say('You already put the grave flower on the blood well.', TALKTYPE_MONSTER_SAY)
			return true
		end
		player:setStorageValue(Storage.FerumbrasAscension.Flower, 1)
	end
	if player:getStorageValue(Storage.FerumbrasAscension.Fount) == 3 then
		for i = 1, #fount do
			local fount = fount[i]
			local founts = Tile(fount.pos):getItemById(fount.revert)
			founts:transform(fount.transformid)
			founts:setActionId(100)
		end
		local statue = Tile(Position(33415, 32379, 12)):getItemById(24819)
		if statue then
			statue:transform(24817)
		end
	end
	if player:getStorageValue(Storage.FerumbrasAscension.Fount) < 0 then
	player:setStorageValue(Storage.FerumbrasAscension.Fount, 0)
	end
	player:setStorageValue(Storage.FerumbrasAscension.Fount, player:getStorageValue(Storage.FerumbrasAscension.Fount) + 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You put the ' ..item:getName().. ' into the dried well.')
	toPosition:sendMagicEffect(CONST_ME_DRAWBLOOD)
	item:remove(1)
	return true
end

ferumbrasAscendantSacrifice:id(2747,10602,24814,24826)
ferumbrasAscendantSacrifice:register()