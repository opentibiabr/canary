local toolGear = Action()

function toolGear.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or not target:isItem() then
		return true
	end

	if math.random(1000) > 10 then
		if onUseKitchenKnife and onUseKitchenKnife(player, item, fromPosition, target, toPosition, isHotkey) then
			return true
		elseif onUseRope and onUseRope(player, item, fromPosition, target, toPosition, isHotkey) then
			return true
		elseif onUseShovel and onUseShovel(player, item, fromPosition, target, toPosition, isHotkey) then
			return true
		elseif onUsePick and onUsePick(player, item, fromPosition, target, toPosition, isHotkey) then
			return true
		elseif onUseMachete and onUseMachete(player, item, fromPosition, target, toPosition, isHotkey) then
			return true
		elseif onUseSpoon and onUseSpoon(player, item, fromPosition, target, toPosition, isHotkey) then
			return true
		end
	else
		player:say("Oh no! Your tool is jammed and can't be used for a minute.", TALKTYPE_MONSTER_SAY)
		if not player:hasAchievement("Bad Timing") then
			player:addAchievementProgress("Bad Timing", 10)
		end
		item:transform(item.itemid + 1)
		item:decay()
	end
	return true
end

toolGear:id(9594)
toolGear:register()
