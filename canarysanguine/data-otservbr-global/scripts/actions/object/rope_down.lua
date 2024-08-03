local cobraBastion = Action()

function cobraBastion.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return false
	end
	player:teleportTo(Position(33394, 32650, 2))
end

cobraBastion:position(Position(33395, 32651, 1))
cobraBastion:register()

local oskayaat = Action()
function oskayaat.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return false
	end
	player:teleportTo(Position(33014, 32983, 8))
end

oskayaat:position(Position(33014, 32983, 7))
oskayaat:register()
