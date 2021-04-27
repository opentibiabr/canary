local gravediggerKey1 = Action()
function gravediggerKey1.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4639 then
		return false
	end

	if player:getStorageValue(Storage.GravediggerOfDrefia.Mission31) == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, '<swoosh> <oomph> <cough, cough>')
		item:remove(1)
		Tile(Position(33071, 32442, 11)):getItemById(9624):transform(9625)
	end
	return true
end

gravediggerKey1:id(21482)
gravediggerKey1:register()