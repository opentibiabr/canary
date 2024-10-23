local skullPosition = Position(33348, 32117, 10)

local actions_museum_sample_blood = Action()

function actions_museum_sample_blood.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target:getPosition() == skullPosition and player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.SkullSample) ~= 1 then
		item:remove(1)
		player:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.SkullSample, 1)
	end

	return true
end

actions_museum_sample_blood:id(27874)
actions_museum_sample_blood:register()
