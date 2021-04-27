local condition = Condition(CONDITION_OUTFIT)
condition:setOutfit({lookTypeEx = 12496})
condition:setTicks(-1)

local wrathEmperorMiss1Crate = Action()
function wrathEmperorMiss1Crate.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.WrathoftheEmperor.CrateStatus) ~= 1 and player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 2 then
		player:addCondition(condition)
		player:setStorageValue(Storage.WrathoftheEmperor.CrateStatus, 1)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

wrathEmperorMiss1Crate:id(12284)
wrathEmperorMiss1Crate:register()