local callback = EventCallback("SecretOnItemMoved")

function callback.onItemMoved(item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	if toPosition == Position(32460, 32928, 7) and item.itemid == 3578 then
		toPosition:sendMagicEffect(CONST_ME_HEARTS)
		player:say("You feed the turtle, now you may pass.", TALKTYPE_MONSTER_SAY)
		Game.setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.SmallIslands.Turtle, os.time() + 10 * 60)
		item:remove(1)
	end
	return true
end

callback:register()
