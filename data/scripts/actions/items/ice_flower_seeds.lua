local iceFlowerSeeds = Action()

function iceFlowerSeeds.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 14029 then
		item:remove(1)
		toPosition:sendMagicEffect(CONST_ME_POFF)
		if not player:hasAchievement("Preservationist") then
			player:addAchievement("Preservationist")
		end
	elseif target.itemid == 306 then
		item:remove(1)
		target:transform(14031)
		target:decay()
		toPosition:sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

iceFlowerSeeds:id(13844)
iceFlowerSeeds:register()
