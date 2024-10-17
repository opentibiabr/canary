local basin = 2113
local finalBasin = Position(33339, 32117, 10)

local actions_museum_bony_rod = Action()

function actions_museum_bony_rod.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 28709 then
		if target.itemid == 27847 then
			item:remove(1)
			target:remove(1)
			player:addItem(28708, 1)
		end
	elseif item.itemid == 28708 then
		if target.itemid == basin then
			item:setAttribute(ITEM_ATTRIBUTE_DURATION, 15 * 1000)
			player:say("Recharging...", TALKTYPE_MONSTER_SAY)
		else
			if target:getPosition() == finalBasin and player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.FinalBasin) ~= 1 then
				target:getPosition():sendMagicEffect(CONST_ME_DRAWBLOOD)
				player:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.FinalBasin, 1)
			end
		end
	end

	return true
end

actions_museum_bony_rod:id(28708, 28709)
actions_museum_bony_rod:register()
