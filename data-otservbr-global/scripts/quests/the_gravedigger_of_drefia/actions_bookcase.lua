local gravediggerBook = Action()
function gravediggerBook.onUse(player, item, fromPosition, itemEx, toPosition)
	if player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Bookcase) < 1 then
		player:setStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Bookcase, 1)
		player:addItem(19158, 1)
		player:say("You have found a crumpled paper.", TALKTYPE_MONSTER_SAY)
	else
		player:say("You've picked up here.", TALKTYPE_MONSTER_SAY)
		return true
	end
	return true
end

gravediggerBook:aid(4669)
gravediggerBook:register()
