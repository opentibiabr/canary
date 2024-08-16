local wrathEmperorMiss4Sacrament = Action()
function wrathEmperorMiss4Sacrament.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getItemCount(11368) >= 1 and player:getItemCount(11369) >= 1 and player:getItemCount(11370) >= 1 and player:getStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Questline) == 10 then
		player:removeItem(11368, 1)
		player:removeItem(11369, 1)
		player:removeItem(11370, 1)
		player:addItem(11371, 1)
		player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
		player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Questline, 11)
		player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Mission04, 2) --Questlog, Wrath of the Emperor "Mission 04: Sacrament of the Snake"
	end
	item:transform(item.itemid == 2772 and 2773 or 2772)
	return true
end

wrathEmperorMiss4Sacrament:uid(1053)
wrathEmperorMiss4Sacrament:register()
