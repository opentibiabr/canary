-- Theodore Loveless' key

local theThievesKey = Action()
function theThievesKey.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.ThievesGuild.Mission06) == 2 then
		if target.actionid == 51394 and item.itemid == 8762 then
			player:removeItem(8762, 1)
			player:say('In your haste you break the key while slipping in.', TALKTYPE_MONSTER_SAY)
			player:teleportTo(Position(32359, 32788, 6))
			return true
		end
	end
	return false
end

theThievesKey:id(8762)
theThievesKey:register()