local ultimateBoozer = Action()
function ultimateBoozer.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 5538 then
		return false
	end

	if player:getStorageValue(Storage.Quest.U8_1.TibiaTales.UltimateBoozeQuest) == 1 then
		player:setStorageValue(Storage.Quest.U8_1.TibiaTales.UltimateBoozeQuest, 2)
	end
	player:removeItem(138, 1)
	player:addItem(136, 1)
	player:say("GULP, GULP, GULP", TALKTYPE_MONSTER_SAY, false, 0, toPosition)
	toPosition:sendMagicEffect(CONST_ME_SOUND_YELLOW)
	return true
end

ultimateBoozer:id(138)
ultimateBoozer:register()
