local condition = Condition(CONDITION_OUTFIT)
condition:setOutfit({lookTypeEx = 11328})
condition:setTicks(-1)

local wrathEmperorMiss1Crate = Action()
function wrathEmperorMiss1Crate.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 2 then
		player:say("You remove its top and pull the crate over yourself. Inside it is stifling and you can barely see a thing when looking outward.", TALKTYPE_MONSTER_SAY)
		player:addCondition(condition)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

wrathEmperorMiss1Crate:id(11328)
wrathEmperorMiss1Crate:register()
