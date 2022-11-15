local brickLayerKit = Action()

function brickLayerKit.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 40027 then
		return false
	end

	player:removeItem(5901, 3)
	player:removeItem(953, 3)
	Game.createItem(1272, 1, Position(32617, 31513, 9))
	Game.createItem(1624, 1, Position(32617, 31514, 9))
	player:removeItem(7785, 1)
	return true
end

brickLayerKit:id(7785)
brickLayerKit:register()
