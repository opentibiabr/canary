local secretServiceBugs = Action()
function secretServiceBugs.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.uid ~= 22005 then
		return false
	end

	if player:getStorageValue(Storage.SecretService.CGBMission03) == 1 then
		player:setStorageValue(Storage.SecretService.CGBMission03, 2)
		item:remove()
		for i = 32909, 32912 do
			Game.createItem(1069, 1, Position(i, 32112, 7))
		end
		player:say('The bugs are at work!', TALKTYPE_MONSTER_SAY)
	end
	return true
end

secretServiceBugs:id(350)
secretServiceBugs:register()
