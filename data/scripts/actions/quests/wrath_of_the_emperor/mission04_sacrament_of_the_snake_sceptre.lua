local wrathEmperorMiss4Sacrament = Action()
function wrathEmperorMiss4Sacrament.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getItemCount(12324) >= 1 and player:getItemCount(12325) >= 1 and player:getItemCount(12326) >= 1 and player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 10 then
		player:removeItem(12324, 1)
		player:removeItem(12325, 1)
		player:removeItem(12326, 1)
		player:addItem(12327, 1)
		player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
		player:setStorageValue(Storage.WrathoftheEmperor.Questline, 11)
		player:setStorageValue(Storage.WrathoftheEmperor.Mission04, 2) --Questlog, Wrath of the Emperor "Mission 04: Sacrament of the Snake"
	end
	item:transform(item.itemid == 1945 and 1946 or 1945)
	return true
end

wrathEmperorMiss4Sacrament:uid(1053)
wrathEmperorMiss4Sacrament:register()