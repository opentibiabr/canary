local keyForge = Action()

function keyForge.onUse(player, item, fromPosition, target, toPosition, isHotkey)
		if target.itemid == 7821 or target.itemid == 7822 or target.itemid == 7823 or target.itemid == 7824 then
			if item.itemid == 27263 then
				item:transform(27266)
				target:decay()
				return true
			elseif item.itemid == 27264 then
				item:transform(27265)
				target:decay()
				return true
			end
		elseif target.itemid == 27266 or target.itemid == 27265 then
			if item.itemid == 27266 then
				target:transform(27267)
				return item:remove(1)
			elseif item.itemid == 27265 then
				target:transform(27267)
				return item:remove(1)
			end
		elseif target.itemid == 3458 then
			if item.itemid == 27267 then
				toPosition:sendMagicEffect(CONST_ME_BLOCKHIT)
				item:transform(27268)
				return true
			end
		elseif target.itemid == 10113 then
			if item.itemid == 27268 then
				toPosition:sendMagicEffect(CONST_ME_POFF)
				item:transform(27269)
				return true
			end
		end
end

keyForge:id(27263,27264,27266,27265,27267,27268)
keyForge:register()
