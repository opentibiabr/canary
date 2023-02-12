local bridgePosition = Position(32801, 32336, 11)

local function revertBridge()
	Tile(bridgePosition):getItemById(5770):transform(622)
end

local function revertLever(position)
	local leverItem = Tile(position):getItemById(2773)
	if leverItem then
		leverItem:transform(2772)
	end
end

local pitsOfInfernoOil = Action()
function pitsOfInfernoOil.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= 2772 then
		return false
	end

	if not Tile(Position(32800, 32339, 11)):getItemById(2886, 7) then
		player:say('The lever is creaking and rusty.', TALKTYPE_MONSTER_SAY)
		return true
	end

	local water = Tile(bridgePosition):getItemById(622)
	if water then
		water:transform(5770)
		addEvent(revertBridge, 10 * 60 * 1000)
	end

	item:transform(2773)
	addEvent(revertLever, 10 * 60 * 1000, toPosition)
	return true
end

pitsOfInfernoOil:uid(1037)
pitsOfInfernoOil:register()