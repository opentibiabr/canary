local secretServiceRing = Action()
function secretServiceRing.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 12563 then
		return false
	end

	if player:getStorageValue(Storage.Quest.U8_1.SecretService.TBIMission05) == 1 then
		player:setStorageValue(Storage.Quest.U8_1.SecretService.TBIMission05, 2)
		item:remove()
		player:say("You have placed the false evidence!", TALKTYPE_MONSTER_SAY)
	end
	return true
end

secretServiceRing:id(349)
secretServiceRing:register()
