local actions_ceirons_waterskin = Action()

function actions_ceirons_waterskin.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 5662 and target.uid == 40096 and player:getStorageValue(Storage.Quest.U7_8.DruidOutfits.CeironsWaterskin) ~= 1 then
		toPosition:sendMagicEffect(CONST_ME_LOSEENERGY)
		item:transform(5939)
		player:setStorageValue(Storage.Quest.U7_8.DruidOutfits.CeironsWaterskin, 1)
		player:say("You have successfully collected a special water sample from the hydra cave.", TALKTYPE_MONSTER_SAY)
	end

	return true
end

actions_ceirons_waterskin:id(5938)
actions_ceirons_waterskin:register()
