local notePos = Position(32598, 32381, 10)

local function removeNote(position)
	local noteItem = Tile(position):getItemById(7872)
	if noteItem then
		noteItem:remove()
	end
end

local theThievesNote = Action()

function theThievesNote.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 12509 then
		return false
	end

	if player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission08) == 1 then
		player:removeItem(7873, 1)
		Game.createItem(7872, 1, notePos)
		player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission08, 2)
		addEvent(removeNote, 5 * 60 * 1000, notePos)
	end
	return true
end

theThievesNote:id(7873)
theThievesNote:register()
