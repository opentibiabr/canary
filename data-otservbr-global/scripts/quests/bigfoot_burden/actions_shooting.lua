local bigfootShooting = Action()
function bigfootShooting.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local playerPos = player:getPosition()
	if player:getStorageValue(Storage.Quest.U9_60.BigfootsBurden.Shooting) < 5 then
		local pos = Position(playerPos.x, playerPos.y - 5, 10)
		local tile = Tile(pos)
		if tile:getItemById(15710) then
			player:setStorageValue(Storage.Quest.U9_60.BigfootsBurden.Shooting, player:getStorageValue(Storage.Quest.U9_60.BigfootsBurden.Shooting) + 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Hit!")
			tile:getItemById(15710):remove()
			pos:sendMagicEffect(CONST_ME_FIREATTACK)
			for i = 2, 4 do
				Position(playerPos.x, playerPos.y - i, 10):sendMagicEffect(CONST_ME_TELEPORT)
			end
			if player:getStorageValue(Storage.Quest.U9_60.BigfootsBurden.Shooting) >= 5 then
				player:setStorageValue(Storage.Quest.U9_60.BigfootsBurden.QuestLine, 14)
			end
		elseif tile:getItemById(15711) then
			player:setStorageValue(Storage.Quest.U9_60.BigfootsBurden.Shooting, 0)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You've hit the wrong target and have to start all over!")
			tile:getItemById(15711):remove()
			pos:sendMagicEffect(CONST_ME_FIREATTACK)
			for i = 2, 4 do
				Position(playerPos.x, playerPos.y - i, 10):sendMagicEffect(CONST_ME_TELEPORT)
			end
		end
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have hit enough targets. Report back!")
	end
	return true
end

bigfootShooting:id(15709)
bigfootShooting:register()
