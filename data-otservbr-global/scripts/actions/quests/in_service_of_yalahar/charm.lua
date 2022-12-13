local inServiceYalaharCharm = Action()
function inServiceYalaharCharm.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid == 100 and target.itemid == 596 then
		if player:getStorageValue(Storage.InServiceofYalahar.Questline) == 36 then
			player:removeItem(8822, 1)
			Game.createItem(8823, 1, toPosition)
			toPosition:sendMagicEffect(CONST_ME_CARNIPHILA)
			local monster
			for i = 1, 2 do
				monster = Game.createMonster('Tormented Ghost', player:getPosition())
				if monster then
					monster:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				end
			end
		end
	end
	return true
end

inServiceYalaharCharm:id(8822)
inServiceYalaharCharm:register()