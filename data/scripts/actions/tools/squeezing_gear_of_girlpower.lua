local toolGear = Action()

local function onUseSickle(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 5463 then
		target:transform(5462)
		target:decay()
		Game.createItem(5466, 1, toPosition)
		return true
	end
	return false
end

function toolGear.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or not target:isItem() then
		return true
	end

	if math.random(1000) > 10 then
		if onUseScythe and onUseScythe(player, item, fromPosition, target, toPosition, isHotkey) then
			return true
		elseif onUseSickle and onUseSickle(player, item, fromPosition, target, toPosition, isHotkey) then
			return true
		elseif onUseRope and onUseRope(player, item, fromPosition, target, toPosition, isHotkey) then
			return true
		elseif onUseShovel and onUseShovel(player, item, fromPosition, target, toPosition, isHotkey) then
			return true
		elseif onUsePick and onUsePick(player, item, fromPosition, target, toPosition, isHotkey) then
			return true
		elseif onUseMachete and onUseMachete(player, item, fromPosition, target, toPosition, isHotkey) then
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

toolGear:id(9596)
toolGear:register()
