local gravediggerBook = Action()
function gravediggerBook.onUse(item, fromPosition, itemEx, toPosition)
	if player:getStorageValue(Storage.GravediggerOfDrefia.Bookcase) < 1 then
		player:setStorageValue(Storage.GravediggerOfDrefia.Bookcase, 1)
		player:addItem(21474,1)
		player:say("You have found a crumpled paper.", TALKTYPE_ORANGE_1)
	else
		player:say("You've picked up here.", TALKTYPE_ORANGE_1)
		return true
	end
	return true
end

gravediggerBook:aid(4669)
gravediggerBook:register()