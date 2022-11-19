local toolgear = Action()

function toolgear.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if math.random(100) > 5 then
		return ActionsLib.useRope(player, item, fromPosition, target, toPosition, isHotkey)
		or ActionsLib.useShovel(player, item, fromPosition, target, toPosition, isHotkey)
		or ActionsLib.usePick(player, item, fromPosition, target, toPosition, isHotkey)
		or ActionsLib.useMachete(player, item, fromPosition, target, toPosition, isHotkey)
		or ActionsLib.useCrowbar(player, item, fromPosition, target, toPosition, isHotkey)
		or ActionsLib.useSpoon(player, item, fromPosition, target, toPosition, isHotkey)
		or ActionsLib.useScythe(player, item, fromPosition, target, toPosition, isHotkey)
		or ActionsLib.useSickle(player, item, fromPosition, target, toPosition, isHotkey)
		or ActionsLib.useKitchenKnife(player, item, fromPosition, target, toPosition, isHotkey)
	else
		player:say("Oh no! Your tool is jammed and can't be used for a minute.", TALKTYPE_MONSTER_SAY)
		item:transform(item.itemid + 1)
		item:decay()
	end
	return true
end

toolgear:id(9594, 9596, 9598)
toolgear:register()
